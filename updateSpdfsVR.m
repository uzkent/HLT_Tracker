function [hist,tt] = updateSpdfsVR(bc,roi,hist,ID,Mask,ml,tt)
% -------------------------------------------------------------------------
%   Explanation :  
%           This function updates the target model (spectral pdfs) by
%           averaging with the assigned blob's model
% -------------------------------------------------------------------------
% Filter the background pixels
rows = round(bc(ID,2)-bc(ID,4)):round(bc(ID,2)+bc(ID,4));
cols = round(bc(ID,1)-bc(ID,3)):round(bc(ID,1)+bc(ID,3));
rows = max(rows,1);
rows = min(rows,size(roi,2));
cols = max(cols,1);
cols = min(cols,size(roi,1));

Rs = max(rows(1)-12:rows(end)+12,1);
Cs = max(cols(1)-12:cols(end)+12,1);
Rs = min(Rs,size(roi,2));
Cs = min(Cs,size(roi,1));    
% Compute the fusion weights
for i = 0:11

    % Comnpute the Distributions
    target_dist = tt.Map_VR(rows,cols,i+1);
    Temp = tt.Map_VR(:,:,i+1);
    Temp(rows,cols) = NaN;
    back_dist = Temp(Rs,Cs);

    % Compute Variances
    num = nanvar(tt.Map_VR(Rs,Cs,i+1)/2);
    p = nanvar(target_dist);
    q = nanvar(back_dist);

    % The Weight for The Likelihood Map
    tt.LF_Weights(i+1) = nanvar(num) / (nanvar(p)+nanvar(q));

end

% Normalize the Weights
tt.LF_Weights = tt.LF_Weights ./ sum(tt.LF_Weights);
tt.LF_Weights = tt.LF_Weights;
