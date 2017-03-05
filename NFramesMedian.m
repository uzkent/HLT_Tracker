function [reference,pan]=NFramesMedian(pan,tt,tm)
%% If There is more than N Number of frames, Get the median image
% Number of frames to be considered
NF = 5;
ref_frame = zeros(size(pan{1},1),size(pan{1},2),NF);
for i = 1:NF
    ref_frame(:,:,i)=pan{i};
end

% Use the ROI for tracking
if tm < 1
    roi_x = tt.user_x(1)-45:tt.user_x(1)+45;
    roi_y = tt.user_y(1)-45:tt.user_y(1)+45;
else
    roi_x = ceil(tt.x{tm}(1)-tt.Kn_Thresh-30:tt.x{tm}(1)+tt.Kn_Thresh+30);
    roi_y = ceil(tt.x{tm}(2)-tt.Kn_Thresh-30:tt.x{tm}(2)+tt.Kn_Thresh+30);
end
roi_x(roi_x<1) = [];    % Ignore the other regions
roi_y(roi_y<1) = [];    

% Sort the Reference Frame Stack
% ref_frame(roi_y,roi_x,:) = sort(ref_frame(roi_y,roi_x,:),3);
ref_frame = sort(ref_frame,3);

% Get the one in the middle
reference = ref_frame(:,:,ceil(NF/2));

pan(1)=[];                        % Update the panchromatic array memory

