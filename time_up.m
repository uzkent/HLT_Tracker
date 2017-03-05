function [imu,isig,z_mu,S]=time_up(model,mu,sig)
%% PERFORMS TIME UPDATE IN S-D ASSIGNMENT ALGORITHM
%==========================================================================
%   Explanation :
%       This function updates state space vector using a physical motion
%       model in the S-D assignment algorithm. It is used to get prior
%       estimates that are utilized by the S-D assignment algorithm to
%       evaluate association costs.
%   Author : Burak Uzkent
%==========================================================================
%% Define the Process Noise and Covariance Noise          
Sw=1;
dt=model.dt;
B=[dt^2 0 0 0 0 0 0;0 dt^2 0 0 0 0 0;0 0 0 0 0 0 0;
  0 0 0 0 0 0 0;0 0 0 0 dt 0 0;0 0 0 0 0 dt 0;
  0 0 0 0 0 0 0.01];
Q = Sw*B;                  % Covariance Noise Matrix
W = diag(normrnd(0,Q));    % Estimate the process noise
%% Covariance and Mean Update Based on Discrete Model
imu= model.FCV * mu + W;
z_mu = model.H*mu;
F = model.FCV;
isig = F * sig * F'+ model.Q;
S=model.H*isig*model.H'+model.R; % Innovation Covariance