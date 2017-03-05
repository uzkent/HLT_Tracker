function [fVector]=WeightedHistogram(roi)
%% ------------------------------------------------------------------------
% Explanation : 
%             This function builds a spectral histogram of region of inter
% est. For each wavelength, a histogram is built. Built histograms for all 
% the wavelengths are concatanated to form a spectral feature vector.
%% ------------------------------------------------------------------------
[rows,cols,bands]=size(roi);    
bins=30;                        % Number of bins
h=1.8;                          % Smoothing parameter
interval=linspace(0,0.75,bins); % Define each bin  (Spatial)
interval(bins+1)=10;            % Extra bin for easing computation

cx = size(roi,1)/2;
cy = size(roi,2)/2;
[xD,yD]=ndgrid((1:rows)-cx,(1:cols)-cy);
Wmap = exp(-sqrt(xD.^2+yD.^2)/h);

zeroInd = find(roi(:,:,1)<0);
Wmap(zeroInd) = 0;
Wmap = Wmap / sum(sum(Wmap));

hist=zeros(bands,bins+1);       % Initiate Histogram Matrix

roi = padarray(roi, [0 0 1]);

for i=1:bands                   % Iterate through each wavelength
        
    data=roi(:,:,i+1);          % Data for the corresponding wavelength
    
    for m=bins:-1:1             % Iterate through each pixel
        
        % Find the pixels fitting the bin m (Spatial)
        Map = (data>interval(m)) & (data<=interval(m+1));
        [ind]=find(Map==1);
                
        % Compute the contribution of the pixels in band i for the bin m
        if ~isempty(ind)
        
            % Contribution is shared between Neighbor Bins
            dist_m = data(ind)-interval(m);
            dist_mplus = interval(m+1) - data(ind);
            cont_sum =  dist_m + dist_mplus;
            cont_m = dist_mplus./cont_sum;
            cont_mplus = dist_m./cont_sum;
            
            % First Bin and Second Bin
            hist(i,m) = hist(i,m) + sum(1 .* cont_m .* Map(ind)); 
            hist(i,m+1) = hist(i,m+1) + sum(1 .* cont_mplus .* Map(ind));
       
        end
        
    end
end

hist = bsxfun(@rdivide, hist,sum(hist,2));
fVector = reshape(hist(:,1:bins)',bands*bins,1);
