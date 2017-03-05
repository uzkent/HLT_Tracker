function [omu,osig]=mu_up_PDAF(model,target,imu,isig,bh,time,n)
%%=========================================================================
%   Explanation : 
%       This function performs measurement update for the probabilistic
%       data association filter.
%   Author : Burak Uzkent
%%=========================================================================
z_mu=[imu(1);imu(2);imu(3);imu(4)]+mvnpdf(model.R,0);% Predicted measurement
h = model.H;         % Jacobian of the measurement model
S= h*isig*h'+model.R;      % Innovation covariance
gain = isig * h' * inv(S); % Gain
index=[3;10;4;11;24;18];
id=target.as{n};
vcom=zeros(1,4)';
iv=target.innov;
B=iv.B;       % Transfer the weights
sigapp=zeros(4,4);
for i=1:size(id,1)
    v=B{n}(id(i))*(bh{time}(id(i),1:4)'-z_mu);
    sigapp=sigapp+iv.B{n}(id(i))*v*v';  
    vcom=vcom+v;            % Combined Innovation
end
sigapp=gain*(sigapp-vcom*vcom')*gain';  % Approximated Covariance
sig_c = isig - gain*S*gain';   % Corrected Covariance
gain(index)=0;      % For time invariant size update
omu = imu + gain*vcom; % Mean Update
osig=iv.Bo{n}*isig+(1-iv.Bo{n})*sig_c; %+sigapp; % Covariance Update