function [im_t] = hsiimageregister(test,ml,tm)
% -------------------------------------------------------------------------
% Explanation :  
%       This function register the input image to the reference image using
%       the homography matrix H.
%           xt = H * x;
% -------------------------------------------------------------------------
u = 1:size(test,2);
v = 1:size(test,1);
[u,v] = meshgrid(u,v) ;

H_All = ones(3,3);
for i = 2:tm
    if i==2
        H_All = H_All .* ml.Ho{i};
    else
        H_All = H_All * ml.Ho{i};
    end
end

H_All = H_All ./ H_All(3,3);

% Map the input image coordinates to the reference 
zt = H_All(3,1) * u + H_All(3,2) * v + H_All(3,3) ;
ut = (H_All(1,1) * u + H_All(1,2) * v + H_All(1,3)) ./ zt ;
vt = (H_All(2,1) * u + H_All(2,2) * v + H_All(2,3)) ./ zt ;

% Interpolate the input image w.r.t the mapped coordinates
im_t = zeros(1200,800,61);
for i = 1:61
    im_t(:,:,i) = interp2(test(:,:,i),ut,vt);
end
