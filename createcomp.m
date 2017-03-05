function [omu]=createcomp(model,x)
%% THIS FUNCTION INITIATES ALL THE GAUSSIAN COMPONENTS AWAY FROM THE MEAN
% =========================================================================
%   Explanation:
%       This function initiates gaussian terms for the GSF. The terms are
%       placed based on the sensor specifications and the orientation of 
%       the target. One term is placed on top of the blob whereas others 
%       are placed within the three sigma away from the mean.
%   Author: Burak Uzkent
% =========================================================================
%Initial sigma value to place the components away from the mean
initSig = model.sig{1};
sig_sqrt = chol(initSig)';
sig_sqrt(2,1) = sig_sqrt(1,1); 

% Transfer the parameters of the detected object
x=cell2mat(x);
omu{1,1}=x';
a=x';

% Define a parameter to iteratively spread the velocities
count=0;
%% Initiate the components by using standard deviation 3
% ------------------------------------------------------------------------------------------------------------    
% IF THE TARGET OF INTEREST IS LOCATED HORIZONTALLY
% ------------------------------------------------------------------------------------------------------------  
if abs(x(3))>abs(x(4)) 
    for j=0:4:model.n-5;        % Define the iterator
        % Increase the counter
        count=count+1;
        % Initiate the components for the particular index value
        if mod(j/4,2)==1
           x(1)=a(1)-count*sig_sqrt(1,1);   
        else
           x(1)=a(1)+count*sig_sqrt(1,1);
        end
        % Assign them to a temporary parameter
        for i=1:2
            omu{1,i+j+1}=x(1:model.fn)'+0.75*i*sig_sqrt(:,1);    % Put the X,Y (+)away from detection
            omu{1,i+j+1+2}=x(1:model.fn)'-0.75*i*sig_sqrt(:,1);  % Put the X,Y (-)away from detection
        end
    end
else
% ------------------------------------------------------------------------------------------------------------    
% IF THE TARGET OF INTEREST IS LOCATED VERTICALLY
% ------------------------------------------------------------------------------------------------------------    
    for j=0:4:model.n-5;        % Define the counter
        % Increase the counter
        count=count+1;
        % Initiate the components for the particular index value
        if mod(j/4,2)==1
           x(2)=a(2)-count*sig_sqrt(1,1);   % Put it (-)away from Y coordinate
        else
           x(2)=a(2)+count*sig_sqrt(1,1);   % Put it (+)away from Y coordinate
        end
        % Assign them to a temporary parameter
        for i=1:2
            omu{1,i+j+1}=x(1:model.fn)'+0.75*i*sig_sqrt(:,1);  % Put the X,Y (+)away from detection
            omu{1,i+j+2+1}=x(1:model.fn)'-0.75*i*sig_sqrt(:,1); % Put the X,Y (-)away from detection
        end
    end
end
%% Add noise to the velocity, acceleration and turn rate components
lim=model.n-1;
variance_vel=sig_sqrt(5:6,5:6); % Define the variance away from the mean
for j=1:2:model.n-1
       % Distribute the velocities
       omu{1,j+1}(5)=omu{1,1}(5)+(j*3/lim)*variance_vel(1,1);
       omu{1,j+1}(6)=omu{1,1}(6)+(j*3/lim)*variance_vel(2,2);
       omu{1,j+2}(5)=omu{1,1}(5)-(j*3/lim)*variance_vel(1,1);
       omu{1,j+2}(6)=omu{1,1}(6)-(j*3/lim)*variance_vel(2,2);
end
%=============================================================================================================
