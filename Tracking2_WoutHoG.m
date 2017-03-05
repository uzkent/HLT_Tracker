%% ------------------------------------------------------------------------
% TRACKING ALGORITHM
% -------------------------------------------------------------------------
% Assign the flag and time value
time=time+1;

% Directory of the HSI Image
Im_1 = matfile(sprintf('../Scenario/Image_%d.mat',I_F+time)); 

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
        target.x{i,time}=x{i,time}'; target.c{i,time}=eye(model.fn)*10;
        
        for j = 1:model.n
            target.mu{time}{i,j}=x{i,time}';
            target.sig{time}{i,j}=eye(model.fn)*10;
        end
    end
else
    %% Initiate the Weights and Components for the First Frame
    [Weight,target]=weightcompinit(model,target,Weight,x,time,cov_init);
    model.matrix=NaN;
    
    %% TIME UPDATE (EXTENDED KALMAN FILTER)
    for j=1:size(x,1)
        
        if isempty(x{j,end})==1           % Skip the dropped track
            continue;
        end
        
        for i = 1 : model.n               % Go through each Gaussian
            mu=target.mu{time}{j,i};      % Validated Track at T(k-1)
            sig=target.sig{time}{j,i};
            model.matrix = 0;             % To draw components on image
            [model,state,sigma{i}]=time_update(model,mu,sig,i,time); 
            target.mu_pred{time}{j,i}=state.c;
            target.sig_pred{time}{j,i}=sigma{i};  % Transfer covariance       
        end
        
        % Compute the mixture estimates for the tracked car (GSF)
        [meanval,covariance] = getGSdata(Weight,target.mu_pred{time},target.sig_pred{time},j,model); 
        target.x_predic{j} = meanval; target.P_predic{j}=covariance;       
        target.Z_predic{j} = model.H*target.x_predic{j};  
        target.S_predic{j} = model.H*target.P_predic{j}*model.H'+ model.R;  
        
        % Map the Track Estimation to the current frame
        [target] = first2current(target,model,j,I_F+1,I_F+time);
        
        %% Sample the ROI for the TOI
        boundary.row = max(ceil(target.mapped{j}(2)-target.Kn_Thresh(2)),1);
        boundary.col = max(ceil(target.mapped{j}(1)-target.Kn_Thresh(1)),1);
        [roi] = sampleROI(boundary,Im_1,target,model,time,roi);
        
        %% Add Noise to the Spectral Data
        roi.sp = NoiseAdd_2(roi.sp);
        
        %% Employ a sliding window approach to get a Distance Map
        [dMap,fMask,target] = SearchTargetROI_WoutHoG(roi.sp,hist,target,model);
        
        %% Generate the blobs 
        [target,f_dist{time},hist]=binary2convex(fMask,dMap,hist,target,time);
        blob = target.wholedetect{time+1}(:,1:5);
        
        %% Update the Histogram and remove the unmatched histograms
        [hist.MatchInd{1,time}]=1:size(blob,1);
        blobCurrent{time}(:,1) = blob(:,1) + boundary.col;
        blobCurrent{time}(:,2) = blob(:,2) + boundary.row;
        blobhist{time}(:,1:2) = blobCurrent{time};  blobhist{time}(:,3:5) = blob(:,3:5);
        
        %% Map the Detection Results to the first frame
        [blobhist] = current2first(blobhist,model,time,I_F+time,I_F+1);
    end

    % Transfer the predictions to the global matrix for measurement update
    target.mu{time}=target.mu_pred{time}; target.sig{time}=target.sig_pred{time};
    
    %% PERFORM DATA ASSOCIATION and MEASUREMENT UPDATE
    target.C=[];        % Cost Matrix
    for tID=1:size(x,1)
        
        if isempty(x{tID,end})==1   % Skip the dropped track
            continue
        end
        
        % Perform S-D Assignment (MHT) (The track has more than N scans)
        [target]=feval(['FA_' model.DA],f_dist,model,hist,target,tID,blobhist,time);
    end
    % Apply Munkres Algorithm to get the best possible matches
    [cost,assig]=min(target.C);
    
    for tID=1:size(x,1)
        
        if isempty(x{tID,end})==1 || isempty(cost)==0 % Skip the dropped track
            if cost >= 1000 || sum(target.tuple(assig,:)) < 1  % If No Match
                target.ss{tID,time}=mu;               % State Space Vector
                target.x{tID,time} = target.x_predic{tID};
                target.c{tID,time} = target.P_predic{j};
                            
                % Assignment History
                ashist(tID,time)=0; target.IDhist{time}=0;
                continue;
            end
        end
        
        % Measurement Update for S-D Assignment
        [target,Weight]=feval(['Prop' model.DA],model,target,tID,assig,blobhist,time,Weight);
        
        % Compute the mixture estimates for the track
        [mu,sig]=getGSdata(Weight,target.mu{time},target.sig{time},tID,model);
        target.x{tID,time}=mu;  target.c{tID,time}=sig;
        target.ss{tID,time}=mu; target.Kn_Thresh = [100 100];
        
        % Assignment history - Update lost tracks
        if target.as{tID}~=0 
            % Update the local target spectral pdfs
            [hist] = updateSpdfs(blob,roi.sp,hist,target.as{tID},fMask,model);
            ashist(tID,time)=1; 
        else ashist(tID,time)=0;
        end     
        target.IDhist{time} = target.as{tID};  
    end
    
    %% Check the cars lost for N number of consecutive frames
    [x,number2]=trackdrop_WoutHoG(ashist,model,target,number2,blobCurrent,Dt,id,roi);
    target.lost=ashist(:,end); % Update index for lost target in current scan
    [target,hist]=deletion(target,hist,time);
end

%% GO BACK TO THE DETECTION PART FOR THE NEXT FRAME
Detection_WoutHoG
