function [meanval,sigval]=CAmodel(model,X,sig)
%% THIS FUNCTION APPLIES THE CA MODEL TO THE GAUSSIAN COMPONENT
% Find the orientation angle and define noise parameters
x=X(1); y=X(2); width=X(3); h=X(4); ax=X(7); ay=X(8); Vx=X(5); Vy=X(6);
Angle=acos(X(6)/X(5))*180/pi;
if abs(Angle)<10  
   alpha=4; Beta=1;
elseif abs(Angle)>80
  alpha=1;  Beta=4;
else 
  alpha=1;  Beta=1;  
end

% Define the noise
Sw=0.3*abs(5+5*rand(1));      % Define the noise amplitude
B=[model.dt^2/alpha 0 0 0 0 0 0 0 0;0 model.dt^2/Beta 0 0 0 0 0 0 0;0 0 0 0 0 0 0 0 0;
   0 0 0 0 0 0 0 0 0;0 0 0 0 model.dt/alpha 0 0 0 0;0 0 0 0 0 model.dt/Beta 0 0 0;
   0 0 0 0 0 0 model.dt/alpha 0 0;0 0 0 0 0 0 0 model.dt/Beta 0;0 0 0 0 0 0 0 0 0];
Q = Sw*B;       % Covariance Noise Matrix
w = diag(normrnd(0,Q));     % Estimate the process noise

% Covariance and Mean Update Based on Discrete Model
meanval = eval(model.fCA) + w;    
F = eval(model.FCA);
sigval = F * sig * F' + Q;