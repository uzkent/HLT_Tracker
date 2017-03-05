function [Mask,target] = otsuthreshold_SeparateBands(Dist,target,ml,time,Index)
% -------------------------------------------------------------------------
%   Explanation : 
%           This function estimates otsu threshold in the current state and
%           estimates the final threshold by averaging the final and first
%           valid thresholds and generates the mask.
% -------------------------------------------------------------------------
%% Normalize Distance Map
Dist(Dist==100) = -5;
Dist(Dist==-5) = max(max(Dist));
Dist = 255 * Dist ./ max(max(Dist));
Temp = uint8(Dist(12:end-11,12:end-11));

%% MultiLevel Thresholding
if time == 2
    target.Sp_Thresh{1} = double(multithresh(Temp,ml.level1));
    target.thresh = target.Sp_Thresh{1};
    target.Sp_Thresh{1}(2:end) = [];
    target.Sp_Thresh{2} = target.Sp_Thresh{1};
    target.Sp_Fthresh{Index} = target.Sp_Thresh{1};
else 
    if target.as{1} ~= 0
        target.Sp_Fthresh{Index} = (ml.alpha*target.Sp_Fthresh{Index}+(1-ml.alpha)*target.Sp_Thresh{2});
        target.Sp_Thresh{2} = double(multithresh(Temp,ml.level2));
        target.thresh = target.Sp_Thresh{2};
        target.Sp_Thresh{2}(2:end) = [];
    end
end

%% Threshold the Mask with ST_{k}
Mask = Dist;
Mask(Mask==0) = 255;
Mask(Mask<target.Sp_Fthresh{Index})=-1;
Mask(Mask>=target.Sp_Fthresh{Index})=1;
Mask(Mask==1) = 0;
Mask(Mask==-1) = 1;