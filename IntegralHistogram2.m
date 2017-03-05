function [histograms] = IntegralHistogram2(roi)
%% ------------------------------------------------------------------------
% Explanation : 
%       This function computes the integral image of the gradient of the
%       image for each bin. For n number of bins, n number of integral
%       images are computed.
%       roi : 3D matrix that contains the spectrum for the ROI 
%% ------------------------------------------------------------------------
[rows,cols,bands]=size(roi);    
bins=10;                        % Number of bins
interval=linspace(0,1,bins);    % Define each bin  (Spatial)
interval(bins+1)=10;            % Extra bin for easing computation
roi = padarray(roi,[0 0 1]);    % Pad extra zero bands

%% Compute the contribution of each pixel in the corresponding bin
% Two closest neighbor is considered. The closer one gets a higher
% magnitude as implemented in the HoG algorithm.
inthist.spatial = cell(1,bands);
[inthist.spatial{1:bands}] = deal(zeros(rows,cols,bins+1));
for k=1:bands
    
    reg = roi(:,:,k+1);
    
    for m=bins:-1:1
        
        % Find the pixels fitting the bin m (Spatial)
        Map = (reg>interval(m)) & (reg<interval(m+1));
        [ind] = find(Map==1);

        % Assign the magnitudes to the corresponding bins
        if ~isempty(ind)
            
            bin1 = zeros(rows,cols);
            bin2 = zeros(rows,cols);
            
            % Compute the closeness of the smaller and larger bin
            cont_small_mag = reg(ind)-interval(m);
            cont_large_mag = interval(m+1)-reg(ind);
            
            % Compute the magnitude to be assigned to small and large bin
            mag_small = cont_large_mag./(cont_large_mag + cont_small_mag);
            mag_large = 1 -  mag_small;
        
            bin1(ind)=mag_small;
            bin2(ind)=mag_large;
            inthist.spatial{k}(:,:,m)=inthist.spatial{k}(:,:,m)+bin1; 
            inthist.spatial{k}(:,:,m+1)=inthist.spatial{k}(:,:,m+1)+bin2; 
        end

    end
end


%% Compute integral images for each bin Image
histograms.spatial = zeros(rows,cols,bands*bins);
for k=1:bands
    inthist.spatial{k}(:,:,bins+1)=[];
    for i=1:bins
        
        % integral image for each bin
        histograms.spatial(:,:,(k-1)*bins+i)=cumsum(cumsum(inthist.spatial{k}(:,:,i)')'); 
    
    end
end