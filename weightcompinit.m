function [Weight,target]=weightcompinit(model,target,Weight,x,time,cov_init)
%% INITIATE THE WEIGHTS AND COMPONENTS IN THE FIRST FRAME      
if cov_init<3
   % Initiate the weights for the current cars 
   for i=1:size(target.detect,1)
       Weight.Measurement{time-1}(i,:)=Weight.initial;
   end
   % Do the assignment for data assoication part
   [target]=initiatemeansigma(target,model,x,cov_init,time);
   % Generate weight parameter for the current frame    
else Weight.Measurement{time}=Weight.Measurement{time-1};
     target.mu{time}=target.mu{time-1};
     target.sig{time}=target.sig{time-1};
end
% Transfer the weights to the current time step
Weight.Measurement{time}=Weight.Measurement{time-1};