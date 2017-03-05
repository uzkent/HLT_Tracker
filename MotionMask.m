function [mMask] = MotionMask(tt,by,time)
% -------------------------------------------------------------------------
%   Explanation :
%       This function generates a motion mask based on the predicted
%       estimates of the target. (Covariance and Mean) 
%       Normal Distribution is assumed to generate the mask.
% -------------------------------------------------------------------------
Gaussians = size(tt.mu{time},2);

%% Estimate Probabilities in the ROI
lHood = zeros(2*tt.Kn_Thresh,2*tt.Kn_Thresh);
rows = 1:2*tt.Kn_Thresh;
cols = 1:2*tt.Kn_Thresh;
[X,Y] = meshgrid(rows,cols);
Xr = reshape(X,rows(end)*cols(end),1);
Yr = reshape(Y,rows(end)*cols(end),1);
Samples = [Yr';Xr']';

%% Go through each Gaussian to estimate mixture density
for g = 1 : Gaussians
    mu(1) = tt.PredMapped{g}(1)-by.col;
    mu(2) = tt.PredMapped{g}(2)-by.row;
    temp = reshape(mvnpdf(Samples,mu,tt.sig_pred{time}{g}(1:2,1:2)),rows(end),cols(end));
    lHood = lHood + temp;
end

%% Normalize the Mask to make the sum equal to 1
mMask = lHood ./ sum(sum(lHood));
