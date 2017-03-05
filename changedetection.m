function [diff]=changedetection(gray_1,gray_2)
%% THIS FUNCTION PERFORMS CHANGE DETECTION ON THE SPECIFIED IMAGES
%% ------------------------------------------------------------------------
% COMPUTE THE DIFFERENCE OF THE FRAMES WITHOUT NORMALIZATION
% FOR ONE BAND (CHANGE DETECTION)
% -------------------------------------------------------------------------
subth = 0.02;                   % Threshold for change detection
gray_2 = gray_2 ./ max(max(gray_2));
gray_1 = gray_1 ./ max(max(gray_1));
diff = abs(gray_2-gray_1);

% [deltaB,~] = imgradient(gray_2);   % Gradient of the detection map
% deltaB= deltaB ./max(max(deltaB)); % Normalize the gradient map
% diff  = abs(diff - deltaB);            

% deltaB(deltaB > subth) = 1;
% deltaB(deltaB < subth) = 2;
% deltaB = deltaB - 1;
% diff = diff .* deltaB;

% If the difference is lower than threshold make the pixel zero
diff(diff<=subth)=0;
% If the difference is higher than threshold make the pixel one
diff(diff>subth)=1;
