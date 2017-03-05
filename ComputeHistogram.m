function [F_Vector]=ComputeHistogram(ih,mu,ml)
%% ------------------------------------------------------------------------
%       Explanation : 
%               This function computes the spatial (for each band) and 
%               spectral histograms given the integral images for each bin
%               in two cases.
%               Inthist: A structure containing the integral images
%               mu :    The location of the Gaussian
%% ------------------------------------------------------------------------
% Determine the boundaries of the Gaussian
mu=abs(mu);
rows=ceil(max(mu(2)-mu(4),1):min(mu(2)+mu(4),ml.im_res(1)));
cols=ceil(max(mu(1)-mu(3),1):min(mu(1)+mu(3),ml.im_res(2)));

% Get the four edge coordinates of the box
rows = rows - ih.y(1);
cols = cols - ih.x(1);

max_rows = size(ih.spatial{1},1);   
max_cols = size(ih.spatial{1},2);

% Avoid having pixels out of the integral image
rows = min(max(rows,1),max_rows);
cols = min(max(cols,1),max_cols);

t_l=[rows(1) cols(1)];
b_l=[rows(end) cols(1)];
t_r = [rows(1) cols(end)];
b_r=[rows(end) cols(end)];
h1 = [];
h2 = [];
bands = size(ih.spatial,2);

% Compute the spatial and spectral histograms
for k=1:bands
    
    % Spectral Histograms
    hist = ih.spectral{k}(b_r(1),b_r(2),:)+ih.spectral{k}(t_l(1),t_l(2),:)-...
    ih.spectral{k}(b_l(1),b_l(2),:)-ih.spectral{k}(t_r(1),t_r(2),:);

    % Spatial Histograms
    hist2 = ih.spatial{k}(b_r(1),b_r(2),:)+ih.spatial{k}(t_l(1),t_l(2),:)-...
    ih.spatial{k}(b_l(1),b_l(2),:)-ih.spatial{k}(t_r(1),t_r(2),:);

    % Normalize each histogram
    hist = reshape(abs(hist),1,10);    
    hist = hist / sum(hist);
    hist2 = reshape(abs(hist2),1,10);
    hist2 = hist2 / sum(hist2);
    
    h1 = [h1; hist'];   % Form a feature vector
    h2 = [h2; hist2'];  % Form a feature vector
end
F_Vector = [h2;h1];     % Concatenate spatial and spectral feature array

