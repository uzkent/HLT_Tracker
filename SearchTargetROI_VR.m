function [Dist,Mask,target] = SearchTargetROI_VR(roi,hist,target,ml,time)
% -------------------------------------------------------------------------
%   Explanation : 
%       This function searches for the TOI in the region of interest using
%       the spectral features. 
%       Hist  = 3D matrix containing the integral spectral histograms with
%       10 bins
%       mVeg = Mask for the vegetation dominated pixels and shadow pixels
%       Dist = Matrix for the detected blobs in the ROI
% -------------------------------------------------------------------------
warning off;
%% Vegetation Mask using NDVI
[mVeg] = ndvi_roi(roi(:,:,23:20:43),ml.Tndvi);

%% Classify the remaining pixels in the Mask as Road-Nonroad Pixels
Mask = roadClassifier(mVeg,roi,ml);

%% Compute the Integral Spectral Histogram for the ROI
[Hist] = IntegralHistogram(padarray(roi,[0,0,1]));
[x] = find(Mask < 2);
Hist = reshape(Hist,size(Hist,1)*size(Hist,2),size(Hist,3));
Hist(x,:) = 0;
Hist = reshape(Hist,size(roi,1),size(roi,2),size(Hist,2));

%% Compute the integral image
for i = 1:size(Hist,3);
     Hist(:,:,i) = cumsum(cumsum(Hist(:,:,i)')');
end

%% Sliding Window Approach - Spectral Histogram Based Search - Distance Map
[Rows,Cols,~] = size(Hist);
N = 12;
target.Map = zeros(Rows,Cols,N);
target.Map_VR = zeros(Rows,Cols,N);
Inc = 50;

%% Compute Individual Likelihood Maps
HSI_Map = zeros(Rows,Cols,3);
HSI_Map_VR = zeros(Rows,Cols,3);
for i = 0:N-1
    
    for j = 1:3
        %% Spectral Search
        rhist = hist.reference_first{j,i+1};
        
        Temp = SpectralSearch(Hist(:,:,i*Inc+1:i*Inc+Inc),Mask,...
        rhist,ml.dims{j}(1),ml.dims{j}(2));

        %% Normalize Distance Map
	Temp_2 = Temp;
        %% Normalize Distance Map
        Temp_2(Temp_2==100) = -5;
	Temp_2(Temp_2==0) = -5;
        Temp_2(Temp_2==-5) = max(max(Temp_2));
        Temp_2 = Temp_2 ./ max(max(Temp_2));
        HSI_Map(:,:,j) = Temp_2;
       
        Temp(Temp==100) = -5;
        Temp(Temp==0) = NaN;
        Temp(Temp==-5) = max(max(Temp));
        Temp = Temp ./ max(max(Temp));
        HSI_Map_VR(:,:,j) = Temp;
    end
    %% Get minimum score
    Temp2 = sort(HSI_Map,3);
    Temp  = sort(HSI_Map_VR,3);

    %% Fuse likelihood maps
    target.Map(:,:,i+1) = Temp2(:,:,3);
    target.Map_VR(:,:,i+1) = Temp(:,:,3);
end

%% Fuse the Likelihood Maps
FinalMap = zeros(Rows,Cols);
for i = 1 : N
    FinalMap = FinalMap + target.LF_Weights(i) .* target.Map(:,:,i);
end

%% Threshold the Mask
[Mask,target] = otsuthreshold_SeparateBands2(FinalMap,target,ml,time,N+1);

%% Perform Morphological Opening
Mask(isnan(Mask)) = 0;
se = strel('rectangle',[5,5]);
Mask = imopen(Mask,se);
 
%% Label the Connected Components - Blobs
[Mask] = bwlabel(Mask);
Dist = FinalMap;
