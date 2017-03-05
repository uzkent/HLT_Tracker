%--------------------------------------------------------------------------
%% READ THE IMAGES AND DETECT THE CARS
%  Author: Burak Uzkent
%--------------------------------------------------------------------------
% GET THE NEXT IMAGE 
if number2 < (I_Fin - I_F)
   k=number2+1;
   number2=number2+1;
else
    
%% EVALUATE THE PERFORMANCE OF THE RUN and FINISH THE PROGRAM
   [metric]=rmse_tp(target,Dt,id,blobCurrent,roi);
   break;
end

%% Match a detection with the selected target
if time+1==1;   
   % Find the Desired object in the user selected ROI
   [target,hist]=matchdetect(target,time,model,I_F);
   flag = 0;
else
   flag = 3;
end
cov_init = cov_init + 1;

%% GO TO THE FILTERING PART
Tracking2_Cascaded
