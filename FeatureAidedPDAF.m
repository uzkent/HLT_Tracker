function [target]=FeatureAidedPDAF(C_feat,time,target,j,bh,C,innov) 
%%==========================================================================
%   Explanation:
%       This function applies feature aided probabilistic data association
%       filter to get the possible assocation for the track of interest.We 
%       only consider the measurements that are matched spectrally.
%   Author : Burak Uzkent
%==========================================================================
S = target.S_predic{j,time}(1:2,1:2);    % Residual Covariance
mu=target.Z_predic{j,time}(1:4);         % Predicted Measurement
ind=find(C_feat{j,time}<target.Sp_Thresh); % Validated Mathces in the gate

%% Probabilistic Data Association Filter Approach    
Vol=pi*chi2inv(0.95,4)*norm(S)^0.5; % Volume of the validation region
Np=10^-3;          % False measurement number per volume unit
lambda=Np/Vol;     % Spatial density of false measurements
P_D = 0.80;        % Probability of Detection
P_G = 0.80;        % Probability of detecting the target in the gate
for i=1:size(ind,2)
   x=bh{time}(ind(i),1:2);  % Measurement 
   mu=mu(1:2);          % Predicted Measurement
   L(ind(i))=2*pi^-0.5*det(S)^-0.5*exp(-0.5*(x'-mu)'*inv(S)*(x'-mu));
   L(ind(i))=L(ind(i))*P_D/lambda;
end
for i=1:size(ind,2)
   B(ind(i))=L(ind(i))/(1-P_D*P_G+sum(L));
end
index=ind;
target.as=index;
if isempty(ind)==0
    innov.Bo{j}=(1-P_D*P_G)/(1-P_D*P_G+sum(L)); % Weight term for i=0
    innov.B{j}=B;                               % Weight term for i=1,2,...n
    target.innov=innov;
end