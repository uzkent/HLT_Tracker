function [U,S,V] = applyPCA(roi)
% -------------------------------------------------------------------------
%   Explanation :
%       This function applies PCA on the region of interest to reduce the
%       dimensionality and maximize the variance.
% -------------------------------------------------------------------------
[rows,cols,bands] = size(roi);
X = reshape(roi,[rows*cols bands]);
avesp = mean(X,2);          % The mean of the region of interest
X0 = X - repmat(avesp,[1 61]); % Subtract from the mean
[U,S,V] = svd(X0,0);        % Perform Singular-Value-Decomposition