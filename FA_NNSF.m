function [target]=FA_NNSF(cf,~,~,target,j,bh,tm)
%% THIS FUNCTION PERFORMS FEATURE-AIDED DATA ASSOCIATION
% =========================================================================
%  Explanation:
%       Spectral Features are utilized to reduce validated measurements
%       Data Association is achieved using the PDAF or NNSF methods.
%       If there is a single validated measurement, it is associated. 
%  Author: Burak Uzkent
% =========================================================================
%% Nearest Neighbor Spatial Filter Approach   
S = target.S_predic{j}(1:2,1:2);    % Residual Covariance
mu=target.Z_predic{j}(1:4);         % Predicted Measurement
C=target.C;

% Compute the costs
for i=1:size(cf{tm},2)

    % Compute likelihood and costs
    iv = mu(1:2)-bh{tm}(i,1:2)';
    lhood = (2*pi)^-1*det(S)^-0.5*exp(-0.5*(iv)'*(S\iv));
    C(j,i) = -log(lhood);

end
% Check the # of cars matched with the track and store the values
C( C > 15 )=1000;
target.C = C;