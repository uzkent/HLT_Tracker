function [meanval,sig]=CVmodel(model,X,sig)
%% THIS APPLIES THE CV MODEL TO THE GAUSSIAN COMPONENT
% Find the orientation angle and define noise parameters
x=X(1); y=X(2); width=X(3); h=X(4); Vx=X(5); Vy=X(6); w=X(7);
Angle=acos(X(6)/X(5))*180/pi; dt=model.dt;
% Determine the noise values based on the target orientation
if abs(mod(real(Angle),90))<10  
   alpha=4; Beta=1;
elseif abs(mod(real(Angle),90))>80
   alpha=1;  Beta=4;
else 
   alpha=1;  Beta=1;  
end

%% Define the Process Noise and Covariance Noise          
a=rand;
if a>0.5
    Sw = 0.3;   % Low noise addition for constant velocity case
else Sw = 7;    % High noise addition to account for rapid accelaration
end
B=[dt^2/alpha 0 0 0 0 0 0;0 dt^2/Beta 0 0 0 0 0;0 0 0 0 0 0 0;
  0 0 0 0 0 0 0;0 0 0 0 dt/alpha 0 0;0 0 0 0 0 dt/Beta 0;
  0 0 0 0 0 0 0.01];
Q = Sw*B;       % Covariance Noise Matrix
W = diag(normrnd(0,Q));    % Estimate the process noise

%% Covariance and Mean Update Based on Discrete Model
meanval= model.FCV * [x y width h Vx Vy w]' + W;
meanval = avoidoutfowkernel(meanval,model);
F = model.FCV;
sig = F * sig * F' + Q;  
