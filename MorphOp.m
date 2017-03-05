function fmask = MorphOp(fmask)
% -------------------------------------------------------------------------
%   Explanation:
%       This function apply morphological erosion and dilation operations
%       to the generated mask
% -------------------------------------------------------------------------
%% Threshold the final mask
fmask(fmask>1.5) = 255;
fmask(fmask<1.5) = 0;

se2 = strel('rectangle',[3 3]);     % Dilation Structure
fmask=imerode(fmask,se2);           % Apply morphological erotion
for i = 1:1
    fmask=imdilate(fmask,se2);          % Apply morphological dilation
end