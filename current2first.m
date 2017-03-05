function [bh] = current2first(bh,ml,tm,in,en)
% -------------------------------------------------------------------------
% Explanation :  
%       This function maps the detection results to the first frame using
%       the cumulative homography
%           xt = H * x;
%       in : Initial frame number
%       en : Frame number to be registered
%       test : image to be registered
% -------------------------------------------------------------------------
% Compute Cumulative Homography
H_All = ones(3,3);
for i = in:-1:en+1
    if i==in
        H_All = H_All .* ml.Ho{i};
    else
        H_All = H_All * ml.Ho{i};
    end
end

% Normalize it w.r.t the homogenous coordinate
H_All = H_All ./ H_All(3,3);
% mFactor = ml.Ho{in}./3.5;
% mFactor(1:4:9) = 1;
% H_All = H_All * mFactor;

% Define the grid
vr = 1:ml.im_res(1);
ur = 1:ml.im_res(2);
[u,v] = meshgrid(ur,vr) ;

% Map the input image coordinates to the reference
zt = H_All(3,1) * u + H_All(3,2) * v + H_All(3,3) ;
ut = (H_All(1,1) * u + H_All(1,2) * v + H_All(1,3)) ./ zt ;
vt = (H_All(2,1) * u + H_All(2,2) * v + H_All(2,3)) ./ zt ;
    
% Find the coordinates in the input imagery
for i = 1:size(bh{tm},1)
    
    % Compute the distance
    dist = abs(ut - bh{tm}(i,1)) + abs(vt - bh{tm}(i,2));
    linearind = find(dist==min(min(dist)));
    [c,r] = ind2sub(size(dist),linearind);
    
    % Assign the new coordinates
    bh{tm}(i,1:2) = [r,c];
end