function [x] = gauss_merge(w,mu)
%
% Get the mean and the covariance of the Gaussian Sum by
% merging all the Gaussian components
%
% x   - estimate the mean
% P   - estimate the covariance
%
% Gabriel Terejanu (terejanu@buffalo.edu)

%% ------------------------------------------------------------------------
% init
%--------------------------------------------------------------------------
ngs = length(w);    % number of Gaussian components
n = size(mu(:,:,1),1);  % dimensionality of the state space
m = size(mu(:,:,1),2);  % dimensionality of the state space

x = zeros(n,m);

%% ------------------------------------------------------------------------
% compute the mean and the covariance
%--------------------------------------------------------------------------
for j = 1 : ngs
    x = x + mu(:,:,j);
end;

x=x./ngs;
