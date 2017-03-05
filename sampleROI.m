function [roi] = sampleROI(boundary,Im_1,target,model,time,roi)
% -------------------------------------------------------------------------
%   Explanation : 
%       This function collects spectral data from the ROI
% -------------------------------------------------------------------------
rows = boundary.row : boundary.row + 2*target.Kn_Thresh(2) - 1;
cols = boundary.col : boundary.col + 2*target.Kn_Thresh(1) - 1;
[indA] = find(rows>model.im_res(1));
[indB] = find(cols>model.im_res(2));
rows([indA;indB])=[];
cols([indA;indB])=[];
roi.boundary{time} = [min(cols) max(cols) min(rows) max(rows)]; 
roi.sp = Im_1.img(rows,cols,:);
