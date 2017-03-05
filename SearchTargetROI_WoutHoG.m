function [Dist,Mask,target] = SearchTargetROI_WoutHoG(roi,hist,target,ml)
% -------------------------------------------------------------------------
%   Explanation : 
%       This function searches for the TOI in the region of interest using
%       the spectral features. 
%       Hist  = 3D matrix containing the integral spectral histograms with
%       10 bins
%       mVeg = Mask for the vegetation dominated pixels and shadow pixels
%       Dist = Matrix for the detected blobs in the ROI
% -------------------------------------------------------------------------
%% Vegetation Mask using NDVI
[mVeg] = ndvi_roi(roi(:,:,23:20:43),ml);

%% Classify the remaining pixels in the Mask as Road-Nonroad Pixels
Mask = roadClassifier(mVeg,roi,ml);

%% Compute the Integral Spectral Histogram for the ROI
[Hist] = IntegralHistogram(padarray(roi(:,:,ml.fIndex:ml.stepSize:ml.lIndex),[0,0,1]));
[x] = find(Mask < 2);
Hist = reshape(Hist,size(Hist,1)*size(Hist,2),size(Hist,3));
Hist(x,:) = 0;
Hist = reshape(Hist,size(roi,1),size(roi,2),size(Hist,2));

% Compute the integral image
for i = 1:size(Hist,3);
     Hist(:,:,i) = cumsum(cumsum(Hist(:,:,i)')');
end

%% Sliding Window Approach - Spectral Histogram Based Search
rHist = hist.reference_first{1}';
Dist = SpectralSearch(Hist,Mask,rHist,ml.dims(1),ml.dims(2));

%% Threshold the Mask
[Mask,target] = otsuthreshold(Dist,target,ml);

%% Perform Morphological Operations
se = strel('rectangle',[3 3]);
Mask = imerode(Mask,se); 
Mask = imdilate(Mask,se); 

%% Label the Connected Components - Blobs
[Mask] = bwlabel(Mask);
