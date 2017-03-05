function [im_t] = imageregister(test,ml,in,en)
% -------------------------------------------------------------------------
% Explanation :  
%       This function register the input image to the reference image using
%       the homography matrix H.
%           xt = H * x;
%       in : Initial frame number
%       en : Frame number to be registered
%       test : image to be registered
% -------------------------------------------------------------------------
u = 1:size(test,2);     % Rows
v = 1:size(test,1);     % Columns
[u,v] = meshgrid(u,v) ;

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

% Map the input image coordinates to the reference
zt = H_All(3,1) * u + H_All(3,2) * v + H_All(3,3) ;
ut = (H_All(1,1) * u + H_All(1,2) * v + H_All(1,3)) ./ zt;
vt = (H_All(2,1) * u + H_All(2,2) * v + H_All(2,3)) ./ zt;

% Interpolate the input image w.r.t the mapped coordinates
im_t = interp_c(double(test),ut,vt);