function [Dist,Mask,target] = SearchTargetROI_Adaptive(roi,hist,target,ml,time)
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
%% Vegetation Mask using NDVI - Binary Vegetation Mask of the Region of Interest
[mVeg] = ndvi_roi(roi(:,:,23:20:43),ml.Tndvi);

%% Classify the remaining pixels in the Mask as Road-Nonroad Pixels
Mask = roadClassifier(mVeg,roi,ml);

%% Compute the Integral Spectral Histogram for the ROI
[Hist] = IntegralHistogram(padarray(roi(:,:,1:5:30),[0,0,1]));
[x] = find(Mask < 2);
Hist = reshape(Hist,size(Hist,1)*size(Hist,2),size(Hist,3));
Hist(x,:) = 0;
Hist = reshape(Hist,size(roi,1),size(roi,2),size(Hist,2));
for i = 1:size(Hist,3);  % Accumulative Sum to Get the ROI
     Hist(:,:,i) = cumsum(cumsum(Hist(:,:,i)')');
end

%% Sliding Window Approach - Spectral Histogram Based Search - Distance Map
[Rows,Cols,Dims] = size(Hist);
Dist = []; 
N = ml.N_LMaps;
Map = zeros(Rows,Cols,N);
N_Pixs = zeros(N,1);
Inc = floor(Dims/N);

% Compute Individual Likelihood Maps from the Spectrum
Inds_N = [];
HSI_Map = zeros(Rows,Cols,3);
for i = 0:N-1
    
    for j = 1:3  % Search Three Different Vehicle Dimensions
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
    % Temp2 = sort(HSI_Map,3);
    Temp2 = sort(HSI_Map,3);
    Dist{i+1} = Temp2(:,:,3);
    
    %% Threshold the Optimal Likelihood Map
    [maskTemp,target] = otsuthreshold_SeparateBands(Dist{i+1}(12:end-11,12:end-11),target,ml,time,i+1);
    
    %% Fuse likelihood maps - Build N Number of Maps
    Map(:,:,i+1) = Temp2(:,:,3);
    
    %% Number of Positive Pixels Detected
    N_Pixs(i+1) = size(maskTemp(maskTemp>0),1);

    %% Indexes of No Detection
    if size(maskTemp(maskTemp>0),1) < 10
        Inds_N = [Inds_N;i+1];
        N_Pixs(i+1) = NaN;
    end
    
end

%% Compute the New Weights
N_Pixs = N_Pixs ./ nansum(N_Pixs);
N_Pixs = 1 - 1./(1+exp(-80*(N_Pixs-0.08)));
N_Pixs = N_Pixs ./ nansum(N_Pixs);
N_Pixs = N_Pixs ./ (1 - sum(target.N_Pixs(Inds_N)));
N_Pixs(Inds_N) = target.N_Pixs(Inds_N);
target.N_Pixs = N_Pixs;

%% Fuse the Likelihood Maps
FinalMap = zeros(Rows,Cols);
for i = 1 : size(N_Pixs,1)
    FinalMap = FinalMap + N_Pixs(i) .* Map(:,:,i);  % Fused Map
    % FinalMap = FinalMap + (1/N) .* Map(:,:,i);    % Classic Likelihood Map Fusion
end

%% Threshold the Fused Map
[Mask,target] = otsuthreshold_SeparateBands2(FinalMap,target,ml,time,N+1);

%% Perform Morphological Opening to Remove Noise
Mask(isnan(Mask)) = 0;
se = strel('rectangle',[3,3]);
Mask = imclose(Mask,se);
 
%% Label the Connected Components - Blobs
[Mask] = bwlabel(Mask);
Dist = FinalMap; % Return the Binary Mask and Distance Map (Fused)
