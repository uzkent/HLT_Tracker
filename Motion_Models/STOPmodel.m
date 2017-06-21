function [meanval,sig]=STOPmodel(model,X,sig)
%% THIS FUNCTION APPLIES STOP MODEL TO THE STATE SPACE MATRIX
% Reference: Tracking Move-Stop-Move Targets with State-Dependent Mode Transition Probabilities
x=X(1); y=X(2); width=X(3); h=X(4); Vx=X(5); Vy=X(6); w=X(7); dt=model. dt; 

Sw=0.1 * randi([20 30],1,1);      % Define the noise amplitude
B=[1/4*dt^4 0 0 0 1/2*dt^3 0 0;0 1/4*dt^4 0 0 0 1/2*dt^3 0;0 0 0 0 0 0 0;
   0 0 0 0 0 0 0;1/2*dt^3 0 0 0 dt^2 0 0;0 1/2*dt^3 0 0 0 dt^2 0;
   0 0 0 0 0 0 0];
Q = Sw^2*B;           % Covariance Noise Term

% Covariance and Mean Update Based on Discrete Model
F = model.FSTOP;
meanval = F * [x y width h Vx Vy w]';
meanval = avoidoutfowkernel(meanval,model);
sig = F * sig * F' + Q;