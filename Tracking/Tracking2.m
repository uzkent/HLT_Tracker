%% ------------------------------------------------------------------------
% TRACKING ALGORITHM
% -------------------------------------------------------------------------
% Assign the flag and time value
time=time+1;
% Directory of the HSI Image - Mat File is Read Partially for Fast Access
Im_1 = matfile(sprintf('../15PM_MovingPlatform_Scenario/FixedHSI/Image_%d.mat',I_F+time));

%% DATA ASSIMILATION
if flag<2
    
    % If the loc parameter is empty,we do tracking based on just measurement
    for i=1:size(target.user_x, 1)
        
        % Transfer the detection values to the loc parameter
        x{i,time}(1:4)=target.detect{i}(1:4); 
        % Define a parameter to inform us about detected targets
        target.newdetected{time}(i)=cellstr('New');
        
        x{i,time}(5:6)=[0,0]; % Initiate the Velocities  
        x{i,time}(model.fn)=i;
        target.x{i,time}=x{i,time}';	    % Initial Target Centroid
 	target.c{i,time}=eye(model.fn)*10;  % Initial Covariance Values
        for j = 1:model.n
            target.mu{time}{i,j}=x{i,time}';
            target.sig{time}{i,j}=eye(model.fn)*50; % The Covariance for each Each Gaussian
        end
    end
else
    %% Initiate the Weights and Components for the First Frame
    [Weight,target]=weightcompinit(model,target,Weight,x,time,cov_init);
    model.matrix=NaN; sample_assign=[]; pixel.tree_count{time}=0; promtrack=1;    
    
    % Initiate the collected spectral data counter 
    target.ds(time)=0; target.vs(time)=0; target.hs(time)=0; target.bs(time)=0;
    
    %% TIME UPDATE (EXTENDED and Linear KALMAN FILTER)
    for j=1:size(x,1)
        
        if isempty(x{j,end})==1           % Skip the dropped track
            continue
        end
        
        for i = 1 : model.n               % Go through each Gaussian
            mu=target.mu{time}{j,i};      % Validated Track at T(k-1)
            sig=target.sig{time}{j,i};
            model.matrix = 0;             % To draw components on image
            [model,state,sigma{i}]=time_update(model,mu,sig,i,time); 
            target.mu_pred{time}{j,i}=state;
            target.sig_pred{time}{j,i}=sigma{i};      % Transfer covariance       
        end
        
        % Compute the mixture estimates for the tracked car (GSF)-  Expected Mean of the Prior PDF
       	%% \param[in] Weight : The Weights to Mix the Gaussians
	%% \param[in] mu_pred : Prediction Estimates for Each Gaussian
	%% \param[in] sig_pred : Covariance for Gaussians
	%% \param[out] meanval : The Mean of the Prior PDF
	%% \param[out] covariance : The Covariance of the Prior PDF
	[meanval,covariance] = getGSdata(Weight,target.mu_pred{time},target.sig_pred{time},j,model); 
        target.x_predic{j} = meanval; target.P_predic{j}=covariance;       
        target.Z_predic{j} = model.H*target.x_predic{j};  
        target.S_predic{j} = model.H*target.P_predic{j}*model.H'+ model.R;  
        
        % Map the Track Statistics to the current frame using the Homography Matrix
        [target] = first2current(target,model,j,I_F+1,I_F+time);
        
        %% Sample the ROI for the TOI
        boundary.row = max(ceil(target.mapped{j}(2)-target.Kn_Thresh(2)),1);
        boundary.col = max(ceil(target.mapped{j}(1)-target.Kn_Thresh(1)),1);
	if (boundary.row + 2*target.Kn_Thresh(2)) > 1500 % Assertion - Do not Sample from Out of the FOV
            boundary.row = boundary.row - (boundary.row - (1500 - 2*target.Kn_Thresh(2)));
        end
        if (boundary.col + 2*target.Kn_Thresh(2)) > 1500 % Do Not Sample from Out of the FOV
            boundary.col = boundary.col - (boundary.col - (1500 - 2*target.Kn_Thresh(2)));
        end
        [roi] = sampleROI(boundary,Im_1,target,model,time,roi); % Sample the ROI Hyperspectrally
        
        %% Add External and Internal Noise to the Spectral Data to Get More Realistic Data
        roi.sp = NoiseAdd(roi.sp,model.NL);
        
        %% Employ a sliding window approach to get a Distance Map - Three Methods (Adaptive Fusion, Classic, VR)
        %% \param[in] roi.sp : Hyperspectral Image of the ROI
	%% \param[in] model.Fusion : The Fusion Method
	%% \param[out] dMap : Final Distance Map
	%% \param[out] fMask : Final Binary Mask
	%% \param[out] target : Updated Target Parameters
	[dMap,fMask,target]=feval(['SearchTargetROI' '_' model.Fusion],roi.sp,hist,target,model,time);  

        % Generate the blobs out of the binary mask using the connected component labeling algorithm
        [target,f_dist{time},hist]=binary2convex(fMask,dMap,hist,target,time);
        blob = target.wholedetect{time+1}(:,1:5);
         
        %% Update the Histogram and remove the unmatched histograms
        [hist.MatchInd{1,time}]=1:size(blob,1);
        blobCurrent{time}(:,1) = blob(:,1) + boundary.col;
        blobCurrent{time}(:,2) = blob(:,2) + boundary.row;
        blobhist{time}(:,1:2) = blobCurrent{time};  
        blobhist{time}(:,3:5) = blob(:,3:5);
        
        %% Map the Detection Results to the first frame using the Accumulated Homography Matrix
        %% \param[in] blobhist : contains the detected blobs at the current time step
	%% \param[out] blobhist : contains the blobs projected to the reference frame
	[blobhist] = current2first(blobhist,model,time,I_F+time,I_F+1);
     
    end

    % Transfer the predictions (GMF) to the global matrix for measurement update
    target.mu{time}=target.mu_pred{time}; 
    target.sig{time}=target.sig_pred{time};
    
    %% PERFORM DATA ASSOCIATION and MEASUREMENT UPDATE
    target.C=[];        % Cost Matrix
    for tID=1:size(x,1)
        
        if isempty(x{tID,end})==1   % Skip the dropped track
            continue
        end
        
        % Perform S-D Assignment (MHT) (The track has more than N scans)
	%% \param[in] model.DA : Data Association Method - (NN, PDAF, S-D)
        [target]=feval(['FA_' model.DA],f_dist,model,hist,target,tID,blobhist,time);
    end

    % Select the one minimizing the S-D Assignment Cost Function
    [cost,assig]=min(target.C);
    for tID=1:size(x,1)
        
        if isempty(x{tID,end})==1 || isempty(cost)==1 % Skip the dropped track
            if cost >= 1000 % || sum(target.tuple(assig,:)) < 1  % If No Match
                target.ss{tID,time}=mu;               % State Space Vector
                target.x{tID,time} = target.x_predic{tID};
                target.c{tID,time} = target.P_predic{j};
                
                % Assignment History
                ashist(tID,time)=0; target.IDhist{time}=0;     
                continue
            end
        end
        
        % Measurement Update for S-D Assignment - Update the Track Statistics - Update Each Gaussian
        [target,Weight]=feval(['Prop' model.DA],model,target,tID,assig,blobhist,time,Weight);
        
        % Compute the mixture estimates for the track - Expected Mean of the Posterior PDF
        [mu,sig] = getGSdata(Weight,target.mu{time},target.sig{time},tID,model);
        [mu_aligned] = first2current_Filter(mu,model,time,I_F+1,I_F+time);
        target.x{tID,time}=mu; 
        target.c{tID,time}=sig;
        target.ss{tID,time}=mu;   
        target.x_aligned{tID,time} = mu_aligned;
        target.Kn_Thresh = [100 100]; %% Update the ROI Dimensions to 200x200 Pixels
        
        % Assignment history - Update lost tracks - To Determine When to Terminate the Track
        if target.as{tID} ~= 0 
            % Update the local target spectral pdfs
            [hist,target] = feval(['updateSpdfs' model.Fusion],blob,roi.sp,hist,target.as{tID},fMask,model,target);
            ashist(tID,time)=1;  
        else ashist(tID,time)=0;
        end
        target.IDhist{time} = target.as{tID};
    end
    
    %% Check the cars lost for N number of consecutive frames
    [x,number2] = trackdrop(ashist,model,target,number2,blobCurrent,Dt,id,roi);
    target.lost = ashist(:,end);              % Update index for lost target
    [target,hist] = deletion(target,hist,time);
    
end
%% GO BACK TO THE DETECTION PART TO READ THE NEXT FRAME
Detection
