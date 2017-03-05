function [F_Vector]=ComputeHistogram2(spatial,rows,cols)
%% ------------------------------------------------------------------------
%       Explanation : 
%               This function computes the spatial (for each band) and 
%               spectral histograms given the integral images for each bin
%               in two cases.
%               Inthist: A structure containing the integral images
%               mu :    The location of the Gaussian
%% ------------------------------------------------------------------------
t_l=[rows(1) cols(1)];
b_l=[rows(end) cols(1)];
t_r=[rows(1) cols(end)];
b_r=[rows(end) cols(end)];
dims = size(spatial,3);

% Spatial Histograms
hist2 = spatial(b_r(1),b_r(2),:)+spatial(t_l(1),t_l(2),:)-...
spatial(b_l(1),b_l(2),:)-spatial(t_r(1),t_r(2),:);

% Normalize each histogram
hist2 = reshape(abs(hist2),1,dims)';

% Concatenate spatial and spectral feature array
F_Vector = hist2; 

% Normalize each histogram for each band
index = 1:dims;
index = reshape(index,10,dims/10);
F_Vector(index)= F_Vector(index) ./ (sum(F_Vector(index(:,1)))+0.0001);
