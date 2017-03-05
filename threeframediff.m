function [mask] = threeframediff(im3,im2,im1)
%--------------------------------------------------------------------------
%   Explanation : 
%       This function performs three frame differencing on the registered
%       images. The result is applied a threshold and a mask is derived at
%       the end.
%       im3 : New Image
%       im2 : Previous Image
%       im1 : Image captured two time steps before
%--------------------------------------------------------------------------
div_1 = abs(im3-im2);
div_2 = abs(im2-im1);

% Perform three frame differencing
mask = min(div_1,div_2);

% Apply a threshold to output the mask
mask(mask > 0.2) = 1;
mask(mask < 0.2) = 0;
