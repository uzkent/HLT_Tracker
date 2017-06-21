function [mean,sig]=CTmodel(model,X,sig)
%% THIS FUNCTION APPLIES THE CT MODEL TO A GAUSSIAN COMPONENT
% Reference: Survey of Maneuvering Target Tracking. Part I: Dynamic Models
% Get the Numerical Values of the State Space Elements
x=X(1); y=X(2); width=X(3); h=X(4); ax=X(7); Vx=X(5); Vy=X(6); 
w=X(7);
dt=model.dt;            % Frame Rate

%% Define the Process Noise
Sw = 0.1*abs(randn(1));   % Define the noise amplitude
% Define covariance of the process noise
B=[2*(w*dt-sin(w*dt))/w^3 0 0 0 (1-cos(w*dt))/w^2 (w*dt-sin(w*dt))/w^2 0;
   0 2*(w*dt-sin(w*dt))/w^3 0 0 -(w*dt-sin(w*dt))/w^2 (1-cos(w*dt))/w^2 0;
   0 0 0 0 0 0 0;
   0 0 0 0 0 0 0;
   (1-cos(w*dt))/w^2 -(w*dt-sin(w*dt))/w^2 0 0 dt 0 0;
   (w*dt-sin(w*dt))/w^2 (1-cos(w*dt))/w^2 0 0 0 dt 0;
   0 0 0 0 0 0 0.01];              
Q = Sw*B;               % Covariance Noise Matrix
W=diag(normrnd(0,Q));   % Estimate the Process Noise

meanval = eval(model.fCT)+ W; % MEAN Update (Current)
mean.c = avoidoutfowkernel(meanval,model);

F = eval(model.FCT);         
sig = F*sig*F' + Q;             % COVARIANCE Update (Future)

dt = 2 * dt;     
meanval = eval(model.fCT)+ W;   % MEAN Update (Future) 
mean.f = avoidoutfowkernel(meanval,model);

