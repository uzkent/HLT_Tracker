function [ginthist]=gradimageintegral(Im)
%% ------------------------------------------------------------------------
% Explanation : 
%       This function computes the integral image of the gradient of the
%       image for each bin. For n number of bins, n number of integral
%       images are computed. 
%% ------------------------------------------------------------------------
bins=9;                             % Number of bins
interval=linspace(-180,180,bins);   % Intervals
data=sum(Im,3);                     % Sum through all bands
[rows,cols] = size(data);
ginthist=zeros(rows,cols,bins);

% Pad the image with zeros
data = padarray(data,[1,1]);

% Create the operators for computing image derivative at every pixel.
hx = [-1,0,1];
hy = hx';

% Compute the derivative in the x and y direction for every pixel.
dx = imfilter(double(data), hx);
dy = imfilter(double(data), hy);

% Remove the 1 pixel border.
dx = dx(2 : (size(dx, 1) - 1), 2 : (size(dx, 2) - 1));
dy = dy(2 : (size(dy, 1) - 1), 2 : (size(dy, 2) - 1)); 

% Convert the gradient vectors to polar coordinates (angle and magnitude).
phase = atan2d(dy, dx);
mag = sqrt((dy.^2) + (dx.^2));

%% Compute the contribution of each pixel in the corresponding bin
% Two closest neighbor is considered. The closer one gets a higher
% magnitude as implemented in the HoG algorithm.
% ginthist = GradIntegralImage(interval,phase,mag,ginthist);
%% Compute integral images for each bin Image
for i=1:rows
    for j=1:cols
        bin_ind_small = find(interval<phase(i,j),1,'last');  % First Bin
        bin_ind_large = find(interval>phase(i,j),1,'first'); % Second Bin
        
        % Compute the closeness of the smaller and larger bin
        cont_small = abs(phase(i,j)-interval(bin_ind_small));
        cont_large = abs(interval(bin_ind_large)-phase(i,j));
        
        % Compute the magnitude to be assigned to small and large bin
        mag_small = mag(i,j) * cont_large/(cont_large + cont_small);
        mag_large = mag(i,j) * (1 - cont_large/(cont_large + cont_small));
        
        % Assign the magnitudes to the corresponding bins
        ginthist(i,j,bin_ind_small)=mag_small; 
        ginthist(i,j,bin_ind_large)=mag_large;
    end
end

ginthist = cumsum(cumsum(ginthist,2)); % integral image for each bin
