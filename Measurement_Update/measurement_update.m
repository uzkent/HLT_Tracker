function [omu,osig,z_mu,S]=measurement_update(model,target,imu,isig,bh,time,n)
%% EKF Measurement Update
z_mu=[imu(1);imu(2);imu(3);imu(4)]+mvnpdf(model.R,0);% Predicted measurement
h = model.H;                % Jacobian of the measurement model
S= h*isig*h'+model.R;       % Innovation covariance
gain = isig * h' * inv(S);  % Gain

%% If there is only one validated measurement 
id=target.as{n};
osig = isig - gain*h*isig;                  % Covariance estimation
index=[3;10;4;11;24;18];
gain(index)=0;
omu = imu + gain*(bh{time}(id,1:4)'-z_mu);    % Mean estimation
plot(omu(1),omu(2),'o','Linewidth',1.5,'MarkerEdgeColor','c','MarkerFaceColor','k','MarkerSize',3)

