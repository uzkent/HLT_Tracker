function [target]=PropagationPDAF(model,target,tID,bh,time)
%% PROPAGATES THE TERMS FOR THE TRACKS WITH HISTORY OF LESS THAN N SCANS
%==========================================================================
%   Explanation :
%       This function propagates the track at T(k-1) to T(k). This function
%       is specific to the 2D assignment algorithm.
%   Author : Burak Uzkent
%==========================================================================
% Perform Measurement Update
for i=1:model.n
    mu=target.mu_pred{time}{tID,i};     % Prior Mean
    sig=target.sig_pred{time}{tID,i};   % Prior Uncertainty
    if isempty(target.as{tID})==0
        [mu,sig]=mu_up_PDAF(model,mu,sig,bh,timetID);
    end
    target.mu{time}{tID,i}=mu;          % Posterior Mean
    target.sig{time}{tID,i}=sig;        % Posterior Uncertainty
end