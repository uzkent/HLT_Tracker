function [flag,cov_init]=flagupdate(flag,z,cov_init)
% This function updates the flag and parameter for covariance matrix
% initializion
if isempty(z)==0
    flag=flag+1;
    cov_init=cov_init+1;
end
