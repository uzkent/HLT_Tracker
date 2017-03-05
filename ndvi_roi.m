function [mask] = ndvi_roi(roi,T)
%--------------------------------------------------------------------------
%   Explanation :
%          This function classify the pixels as vegetation or
%          non-vegetation using the NDVI index.
%--------------------------------------------------------------------------
data = zeros(size(roi,1),size(roi,2),2);
data(:,:,1) = roi(:,:,1);
data(:,:,2) = roi(:,:,2);
NIR = data(:,:,2);
VIS = data(:,:,1);
mask = (NIR - VIS) ./ (NIR + VIS);
mask(mask>T)=10;
mask(mask<T)=11;
mask = mask - 10;
