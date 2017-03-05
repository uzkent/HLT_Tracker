function [mu] = first2current_Filter(mu,ml,tm,in,en)
% -------------------------------------------------------------------------
% Explanation :  
%       This function maps the detection results to the first frame using
%       the cumulative homography
%           xt = H * x;
%       in : Initial frame number
%       en : Frame number to be registered
%       test : image to be registered
% -------------------------------------------------------------------------
% Define the grid
vr = 1:ml.im_res(1);
ur = 1:ml.im_res(2);
[u,v] = meshgrid(ur,vr) ;

% Compute Cumulative Homography
H_All = ones(3,3);
for i = in+1:en
    if i==in+1
        H_All = H_All .* inv(ml.Ho{i});
    else
        H_All = H_All/ml.Ho{i};
    end
end

% Normalize it w.r.t the homogenous coordinate
H_All = H_All ./ H_All(3,3);     
% mFactor = ml.Ho{en}./3.5;
% mFactor(1:4:9) = 1;
% H_All = H_All * inv(mFactor);


% Map the input image coordinates to the reference
zt = H_All(3,1) * u + H_All(3,2) * v + H_All(3,3) ;
ut = (H_All(1,1) * u + H_All(1,2) * v + H_All(1,3)) ./ zt ;
vt = (H_All(2,1) * u + H_All(2,2) * v + H_All(2,3)) ./ zt ;

% Compute the distance
dist = abs(ut - mu(1)) + abs(vt - mu(2));
linearind = find(dist==min(min(dist)));
[c,r] = ind2sub(size(dist),linearind);

mu = [r,c];