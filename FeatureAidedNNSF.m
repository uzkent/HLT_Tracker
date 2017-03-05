function [target]=FeatureAidedNNSF(C_feat,time,target,j,bh,C_kin,iv)
%% THIS FUNCTION PERFORMS FEATURE-AIDED DATA ASSOCIATION
% =========================================================================
%  Explanation:
%       Spectral Features are utilized to reduce validated measurements
%       Data Association is achieved using the PDAF or NNSF methods.
%       If there is a single validated measurement, it is associated. 
%  Author: Burak Uzkent
% =========================================================================
%% Nearest Neighbor Spatial Filter Approach   
S = target.S_predic{j,time}(1:2,1:2);    % Residual Covariance
mu=target.Z_predic{j,time}(1:4);         % Predicted Measurement
for i=1:size(bh{time},1)
    % Euclidean Cost
    C_kin(j,i)=sqrt((mu(1)-bh{time}(i,1))^2+(mu(2)-bh{time}(i,2))^2);
end
% Check the # of cars matched with the track and store the values
C_kin(C_kin>45)=1000;
ind=find(C_feat{j,time}>target.Sp_Thresh);
ind2=find(isnan(C_feat{j,time}));
C_kin(j,[ind ind2])=1000;      % If no match spectrally, apply a high penalty 
C_kin(C_kin==0)=1000;
target.C_kin = C_kin;