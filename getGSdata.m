function [omu,osig] = getGSdata(Weight,mu,sig,tID,model)
%   
% Get the estimates for one particular Gaussian Sum
%
% omu   - estimate the mean
% osig  - estimate the covariance
%
% Gabriel Terejanu (terejanu@buffalo.edu)

%% ------------------------------------------------------------------------
% omu - compute the mean of the Gaussian Sum
% osig - compute the covariance of the Gaussian Sum
%--------------------------------------------------------------------------
iweig=Weight.Measurement{1};
for i=1:model.n
    for j=1:model.fn
        try
        imu{j,i}=mu{tID,i}(j);
        catch err;
            e = 2;
        end
    end
    isig{i}=sig{tID,i};
end
[omu,osig] = merge(iweig,imu,isig);
