function [omu]=createcompnewcar(model,target,time)
%% This function creates all the 37 gaussian components
%Define the initial covariance value
initSig = 10*eye(model.fn);
sig_sqrt = chol(initSig)';
x=target.curmloc{time}(size(target.curmloc{time},1),1:model.fn);
omu{1,1}=x';
countmax=((model.n-13)/12+1)/3;
count=0;
for j=0:12:model.n-13;
    count=count+1;
     for i =1:model.fn
         %omu{1,i+j+1} = x(1:model.fn) + ((j+1)/model.fn)*(18/model.n-12)*sig_sqrt(1:model.fn,i)'; % Gives 6 components for i = 2 to 7
         %omu{1,i+j+7} = x(1:model.fn) + ((j+1)/(-model.fn))*(18/model.n-12)*sig_sqrt(1:model.fn,i)'; % Gives 6 components for i = 2 to 7
         omu{1,i+j+1} = x(1:model.fn)' + (count/countmax)*sig_sqrt(1:model.fn,i); % Gives 6 components for i = 2 to 7
         omu{1,i+j+1}(3:4)=abs(omu{1,i+j+1}(3:4));
         omu{1,i+j+model.fn+1} = x(1:model.fn)' - (count/countmax)*sig_sqrt(1:model.fn,i); % Gives 6 components for i = 2 to 7
         omu{1,i+j+model.fn+1}(3:4)=abs(omu{1,i+j+model.fn+1}(3:4));
         %omu{1,i+j+1} = x(1:model.fn)' + 0.2*i*x'; % Gives 6 components for i = 2 to 7
         %omu{1,i+j+7} = x(1:model.fn)' - 0.2*i*x'; % Gives 6 components for i = 2 to 7
     end
end
%target.mu{1}(size(target.mu{1},1)+1,:)=omu;
%omu{1,4}=x;
%omu{1,2}=x'+0.05*x';
%omu{1,3}=x'-0.05*x';
%omu{1,2}=x'+0.05*x';
%omu{1,3}=x'-0.05*x';
%omu{1,4}=x'+0.1*x';
%omu{1,5}=x'-0.1*x';
% omu{1,6}=x'+0.15*x';
% omu{1,7}=x'-0.15*x';
% omu{1,8}=x'+0.2*x';
% omu{1,9}=x'-0.2*x';
% omu{1,10}=x'+0.25*x';
% omu{1,11}=x'-0.25*x';
% omu{1,12}=x'+0.3*x';
% omu{1,13}=x'-0.3*x';