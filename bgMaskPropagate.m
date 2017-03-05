function [maskFinal] = bgMaskPropagate(mask,tt,ID)
% -------------------------------------------------------------------------
%   Explanation : 
%       This function propogates the background subtraction foreground mask_temp
%       to the time of the end of the roi spectra acquisition (~0.2s).
%       Target's predicted velocity is used to propagate the mask_temp. N
%       different velocities are selected from the Gaussian distribution.
%       Once N number of virtual mask_temps are generated. The maximum value for
%       the pixel in n frames are chosen to generate the final mask_temp.
% -------------------------------------------------------------------------
mu = tt.x_predic{ID}(5:6)/5;
sig = tt.P_predic{ID}(5:6,5:6)/5;

% Dimensions of the ROI
[rows,cols] = size(mask);

% Generate virtual mask_temps
NF = 10;
maskVirtual = zeros(rows,cols,NF);
maskFinal = zeros(rows,cols);
for i = 1:NF
    
    mask_temp = mask;
    % Randomly generate velocities from a Gaussian Distrubtion
    muRandom = round(mvnrnd(mu',sig));
    
    % Decide if we need to go up, or down and right or left
    if muRandom(1) < 0 && muRandom(2) < 0
        muRandom = abs(muRandom);
        mask_temp = [mask_temp zeros(rows,muRandom(1))];
        mask_temp = [mask_temp ; zeros(muRandom(2),size(mask_temp,2))];
        mask_temp = mask_temp(1:rows,1:cols);
    elseif muRandom(1) > 0 && muRandom(2) < 0
        muRandom = abs(muRandom);
        mask_temp = [zeros(rows,muRandom(1)) mask_temp];
        mask_temp = [mask_temp ; zeros(muRandom(2),size(mask_temp,2))];
        mask_temp = mask_temp(muRandom(2)+1:end,1:cols);
    elseif muRandom(1) > 0 && muRandom(2) > 0
        muRandom = abs(muRandom);
        mask_temp = [zeros(rows,muRandom(1)) mask_temp];
        mask_temp = [zeros(muRandom(2),size(mask_temp,2)) ; mask_temp];
        mask_temp = mask_temp(muRandom(2)+1:end,muRandom(1)+1:end);
    else
        muRandom = abs(muRandom);
        mask_temp = [mask_temp zeros(rows,muRandom(1))];
        mask_temp = [zeros(muRandom(2),size(mask_temp,2)) ; mask_temp];
        mask_temp = mask_temp(1:rows,muRandom(1)+1:end);
    end
    
    maskVirtual(:,:,i) = mask_temp; % Transfer to the virtual mask_temp cell array
    maskFinal = max(maskFinal,maskVirtual(:,:,i));
end

