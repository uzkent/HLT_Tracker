function l=getlikelihood_2(r,sig,sig_up,mu,mu_up,R)
%% THIS FUNCTION PERFORMS MEASUREMENT WEIGHT UPDATE BASED ON COLLOCATION CONDITION ON MEAN
% Scale down the parameters not to lose weights quickly
sp=200;
% Scale the parameters
r=r/sp; sig=sig/sp; sig_up=sig_up/sp; mu=mu/sp; mu_up=mu_up/sp; R=R/sp;
% Evaluate the weights
l=sqrt(det(sig_up)/det(sig))*exp(-(r'*inv(R)*r/2)+(mu_up-mu)'*inv(sig)*(mu_up-mu));