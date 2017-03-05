function [Weights]=avoiddegeneracy(Weights,model)
%% THIS FUNCTION AVOIDS DEGENERACY OF THE WEIGHTS
% The paper cited : "An Adaptive Gaussian Sum ALgorithm for Radar Tracking"
% Normalize the weights
if sum(Weights)>0
   Weights=Weights./sum(Weights);
end
Neff=0; N=model.n;  % Perform Initialization
for i=1:model.n
    if Weights(i)>10^-4
       Neff=Neff+Weights(i)^-2; % Estimate the efficient number of components
    end
end
alpha=Neff/N;                   % Define the alpha parameter
for i=1:model.n
    Weights(i)=alpha*Weights(i)+(1-alpha)/N;% Estimate the updated weights
end
Weights=abs(Weights)./sum(abs(Weights));    % Normalize the updated weights