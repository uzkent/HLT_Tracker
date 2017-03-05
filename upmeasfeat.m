function [target,hist,bh,f_dist,vmeas]=upmeasfeat(target,bh,n,ID,f_dist,time,hist,dist,vmeas)
%% THIS FUNCTION UPDATES THE MEASUREMENT AND FEATURE COST ARRAY
% Only update it if the object matches the track
if dist < target.Sp_G_Thresh
   mu=target.mu_pred{time}{n,ID};           % Prediction Estimations
   nsize=size(bh{time},1);
   bh{time}(nsize+1,:)=[mu(1:2)',3.5,3.5];  % Update the measurements
   ang = atan(mu(6)/mu(5));         
   target.detect{time}(nsize+1,:)=[mu(1:2)',3.5,3.5,ang];
   f_dist{n,time}(nsize+1)=dist;            % Update feature cost array
   f_dist{n,time}(f_dist{n,time}==0)=NaN;   
   [hist]=spectraremove(hist,ID,1,time);    % Remove unmatched spectra
else
   [hist]=spectraremove(hist,0,1,time);     % Remove unmatched spectra
end
[hist.MatchInd{n,time}]=find(f_dist{n,time}<target.Sp_Thresh);
[vmeas{n,time}]=find(f_dist{n,time}<target.Sp_Thresh);
