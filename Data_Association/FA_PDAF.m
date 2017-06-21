function [target]=FA_PDAF(C_feat,~,~,target,j,bh,tm) 
%%==========================================================================
%   Explanation:
%       This function applies feature aided probabilistic data association
%       filter to get the possible assocation for the track of interest.We 
%       only consider the measurements that are matched spectrally.
%   Author : Burak Uzkent
%==========================================================================
S = target.S_predic{j}(1:2,1:2);        % Residual Covariance
mu=target.Z_predic{j}(1:4);             % Predicted Measurement
S = S + 20*eye(2);
ind=find(C_feat{j,tm}<10); % Validated Mathces in the gate

%% Probabilistic Data Association Filter Approach
Vol=pi*chi2inv(0.90,4)*norm(S)^0.5; % Volume of the validation region
Np=0.1;            % False measurement number per volume unit
lambda=Np/Vol;     % Spatial density of false measurements
P_D = 0.90;        % Probability of Detection
P_G = 0.90;        % Probability of detecting the target in the gate

for i=1:size(ind,2)
   x=bh{tm}(ind(i),1:2);  % Measurement 
   mu=mu(1:2);            % Predicted Measurement
   L(ind(i))=2*pi^-0.5*det(S)^-0.5*exp(-0.5*(x'-mu)'*inv(S)*(x'-mu));
   L(ind(i))=L(ind(i))*P_D/lambda;
end

target.as{j}=ind;
if isempty(ind)==0
    target.innov.B{j}=L/(1-P_D*P_G+sum(L));      % Weight term for nonzero i  
    target.innov.Bo{j}=(1-P_D*P_G)/(1-P_D*P_G+sum(L)); % Weight term for i=0
    temp=sum(target.innov.B{j})+sum(target.innov.Bo{j});
    target.innov.B{j}=target.innov.B{j}/temp;
    target.innov.Bo{j}=target.innov.Bo{j}/temp;
else
    target.innov.B{j} = 0;
    target.innov.Bo{j} = 1;
end
if tm == 2
   target.innov.B{j} = 1; 
   target.innov.Bo{j} = 0;
end