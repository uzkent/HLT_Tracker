function [mu,number2]=trackdrop(ashist,model,target,number2,blobCurrent,Dt,id,roi)
%% CHECK IF ANY TRACK IS LOST N NUMBER OF CONSECUTIVE FRAMES
%==========================================================================
%   Explanation : 
%       This function checks if any track is lost for N number of
%       consecutive frames. If it is lost then the track is dropped. No new
%       track initiation is performed. If all the tracks are dropped then
%       an alert is displayed on the screen.
%   Author : Burak Uzkent
%==========================================================================
c=1;
mu=target.x;
if size(ashist,2)>model.D+1
    for i=1:size(ashist,1)
        temp=ashist(i,end-model.D:end);  % Consider last N frames
        if sum(temp)<1                   % No match in the last N frames?
            drindex(c)=i;
            c=c+1;
            mu{drindex,end}=[];      % Update the corresponding vector
            % msgbox('No target left to tracked!!!') % Display alert
            number2=10^3;
            I_Fin = 0; I_F = 0;
            Detection;
        end
    end
end
