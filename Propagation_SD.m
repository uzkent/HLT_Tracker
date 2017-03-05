function [target,Weight]=Propagation_SD(model,target,tID,ind,bh,time,Weight)
%% PROPAGATES THE TRACK AT T(k-S+1) to T(k)
%==========================================================================
%   Explanation:
%       This function propagates the track at T(k-S+1) to the current time
%       step. This function is only specific to the Multidimensional Data
%       Association. Here, we only propagate the mixture mean. Individual
%       Gaussian terms are not considered.
%==========================================================================
% Number of Scans
N=size(ind,2)+1;
% Propagation
c=1;
for i=N:-1:2
    if ind(c)~=0
        meas=bh{time-i+2}(ind(c),:);   % Assigned measurement
    else meas=[];
    end
    for j=1:model.n
        X=target.mu{time-i+1}{tID,j};           % Track at T(k-S+1)
        sig=target.sig{time-i+1}{tID,j};
        [mu,sig,z_mu]=SD_time_up(model,X,sig);  % Time Update T(k-S+2)
        % Measurement Update T(k-S+2)
        if isempty(meas)==0;
            [mu,sig,z_sig]=SD_meas_up(model,mu,sig,meas');
        end
        target.mu{time-i+2}{tID,j}=mu;
        target.sig{time-i+2}{tID,j}=sig;
        if i==2 && ind(c)~=0;
            % Update the weights using the classical weight update method
            Weights(j) = Weight.Measurement{time}(tID,j);
            Weights(j) = Weights(j)*getLikelihood((bh{time}(ind(c),:)'-z_mu),z_sig+model.R);
        end
    end
    c=c+1;
end
% Normalize the weights
if ind(c-1)~=0
    if sum(Weights)>0
        Weights=Weights./sum(Weights);
    end
    % Avoid degeneration of the weights
    [Weights]=avoiddegeneracy(Weights,model); 
    Weight.Measurement{time}(tID,:)=Weights;
end