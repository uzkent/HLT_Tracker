function [target]=initiatemeansigma(target,model,promloc,cov_init,time)
%% THIS FUNCTION PERFORMS INITIATIONS    
for m=1:size(promloc,1)
    % Transfer the locations in the previous frame to x
    x=promloc(m,:);
    % Create Gaussian Components
    [omu]=createcomp(model,x);
    % Transfer the mean values of components to the mu parameter
    target.mu{time}(m,:)=omu;
    % Initalize the covariance matrix for the first frame        
    if cov_init<3
    % Covariance Matrix for the gaussian components    
    target.sig{time}(m,:)=model.sig;
    end
end
   
    