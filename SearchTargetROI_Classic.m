function [Dist,Mask,target] = SearchTargetROI_Classic(roi,hist,target,ml,time)
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
[Hist] = IntegralHistogram(padarray(roi...
    ,[0,0,1]));
[x] = find(Mask < 2);
Hist = reshape(Hist,size(Hist,1)*size(Hist,2),size(Hist,3));
Hist(x,:) = 0;
Hist = reshape(Hist,size(roi,1),size(roi,2),size(Hist,2));

% Compute the integral image
for i = 1:size(Hist,3);
     Hist(:,:,i) = cumsum(cumsum(Hist(:,:,i)')');
end

%% Sliding Window Approach - Spectral Histogram Based Search - Distance Map
[Rows,Cols,Dims] = size(Hist);
Bins = 10;
Dist = [];
N = 12;
Map = zeros(Rows,Cols,N);
N_Pixs = zeros(N,1);
Inc = 50;

% Compute Individual Likelihood Maps
Inds_N = [];
HSI_Map = zeros(Rows,Cols,3);
for i = 0:N-1
    
    for j = 1:3
        %% Spectral Search
        rhist = hist.reference_first{j,i+1};
        
        Temp = SpectralSearch(Hist(:,:,i*Inc+1:i*Inc+Inc),Mask,...
        rhist,ml.dims{j}(1),ml.dims{j}(2));

        %% Normalize Distance Map
        Temp(Temp==100) = -5;
        Temp(Temp==0) = -5;
        Temp(Temp==-5) = max(max(Temp));
        Temp = Temp ./ max(max(Temp));
        HSI_Map(:,:,j) = Temp;
    
    end
    Temp2 = sort(HSI_Map,3);
    Dist{i+1} = Temp2(:,:,3);
    
    %% Threshold the Mask
    [maskTemp,target] = otsuthreshold_SeparateBands(Dist{i+1}(12:end-11,12:end-11),target,ml,time,i+1);
    
    %% Fuse likelihood maps
    Map(:,:,i+1) = Temp2(:,:,3);
    
    %% Number of Pixels Detected
    N_Pixs(i+1) = size(maskTemp(maskTemp>0),1);

    %% Indexes of No Detection
    if size(maskTemp(maskTemp>0),1) < 10
        Inds_N = [Inds_N;i+1];
        N_Pixs(i+1) = NaN;
    end
    
end

%% Compute the Weights
N_Pixs = N_Pixs ./ nansum(N_Pixs);
N_Pixs = 1 - 1./(1+exp(-80*(N_Pixs-0.08)));
N_Pixs = N_Pixs ./ nansum(N_Pixs);
N_Pixs = N_Pixs ./ (1 - sum(target.N_Pixs(Inds_N)));
N_Pixs(Inds_N) = target.N_Pixs(Inds_N);
target.N_Pixs = N_Pixs;

%% Fuse the Likelihood Maps
FinalMap = zeros(Rows,Cols);
for i = 1 : size(N_Pixs,1)
    FinalMap = FinalMap + (1/N) .* Map(:,:,i);
end

%% Threshold the Mask
[Mask,target] = otsuthreshold_SeparateBands2(FinalMap,target,ml,time,N+1);

% %% Detect Vehicles
% [Detections] = HoGSearchROI(roi,Mask,ml);
% Mask(Mask~=0) = 0;
% for i = 1 : size(Detections,1)
%      Mask(Detections(i,2)-5:Detections(i,2)+4,Detections(i,1)-5:Detections(i,1)+4) = 1;
% end

%% Perform Morphological Opening
Mask(isnan(Mask)) = 0;
se = strel('rectangle',[5,5]);
Mask = imopen(Mask,se);
 
%% Label the Connected Components - Blobs
[Mask] = bwlabel(Mask);
Dist = FinalMap;
