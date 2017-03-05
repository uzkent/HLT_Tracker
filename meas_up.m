function [omu,osig,S]=meas_up(model,mu,isig,v)
%% PROPAGATE THE MIXTURE MEAN FOR EVALUATING S-D ASSINGMENT COSTS
%==========================================================================  
%   Explanation : 
%       This function updates the prior state space info with the candidate
%       assignment to evaluate assignment costs. Here, we consider the
%       mixture state space matrix. Individual Gaussians are not
%       considered.
%   Author : Burak Uzkent
%==========================================================================  
noise_mu = zeros(4,1);
noise = mvnrnd(noise_mu,model.R)';
z_mu = [mu(1);mu(2);mu(3);mu(4)]+noise;     % Predicted measurement
h = model.H;      % Jacobian of the measurement model (Same with itself)
S = h*isig*h'+model.R;                      % Innovation covariance
gain = isig * h'/(S);                       % Gain
osig = isig - gain*h*isig;                  % Covariance estimation
omu = mu + gain*(v(1:4)-z_mu);              % Mean estimation