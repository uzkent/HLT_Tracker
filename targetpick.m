function [target,hist]=targetpick(target,ml,pan,hsi)
%% THIS FUNCTION PICKS THE CLOSEST TARGET TO THE USER'S PICK and COLLECTS SPECTRAL FEATURES
% Convert it to panchromatic image
% imshow(pan,[0 max(max(pan))]); % Ask the user to pick a target from the frame
% zoom on;
% waitfor(gcf,'CurrentCharacter',13);
% zoom reset
% zoom off
% [target.user_x,target.user_y,but]=ginput(5);       % User pick a target 
% target.user_x(1,1)=7; target.user_y(1,1)=33;         % User pick coordinates
% target.user_x(2,1)=415; target.user_y(2,1)=38;     % User pick coordinates
% close;

%% Collect spectral features from the user picked target for feature matching
% for i=1:size(target.user_y)
%     
%     % Determine rows and cols to be sampled
%     rows=floor(target.user_y(i,1))-15:floor(target.user_y(i,1))+14; 
%     cols=floor(target.user_x(i,1))-15:floor(target.user_x(i,1))+14; 
%     temp_sp=hsi.Image(rows,cols,:);  % Collect features 
%     temp_pan=pan(rows,cols);         % Collect grayscale image
%     
%     % Compute the integral gradient image for each bin
%     [ginthist]=gradimageintegral(temp_pan);
%       
%     numRows=10;    % Dimensions of the detection window
%     numCols=20;
%       
%     % Go through each window, compute HoG and detect the region as
%     % positive or negative
%     c=1;
%     for row=numRows:5:size(temp_pan,1)
%         for col=numCols:5:size(temp_pan,2)
%              % Compute the HoG feature vector 
%              [test_data]=HoGdescriptor(ginthist(row-numRows+1:row,col-numCols+1:col,:)); 
%              % Predict the label of the window
%              [~,~,prob_est(c)]=svmpredict(-1,test_data', ml.linearSVM,'-q');
%              sample_rows(c)=row;
%              sample_cols(c)=col;
%              c=c+1;
%         end
%     end
%     
%     %% Non-maximum Suppression
%     [max_value,max_index]=max(prob_est);
%     if max_value > 0.150
%         % Sample the maximum detection window
%         rows_samp=sample_rows(max_index)-numRows+1:sample_rows(max_index);
%         cols_samp=sample_cols(max_index)-numCols+1:sample_cols(max_index);
%         temp_sp=temp_sp(rows_samp,cols_samp,:);
% 
%         % Collect Spectral Histogram  
%         [sphist]=WeightedHistogram(temp_sp);
%         hist.pred{i,1}{1,1}=sphist;
%         % hist.pred{i,1}{2,1}=hog;
%         target.userpickspect{i}=sphist;
%         for j=2:ml.n
%             hist.pred{i,1}{1,j}=[]; % Assign the histogram to the all components
%             hist.pred{i,1}{2,j}=[]; % Assign the histogram to the all components
%         end
%     end
% end