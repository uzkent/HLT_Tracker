function [hist,tt] = updateSpdfsAdaptive(bc,roi,hist,ID,Mask,ml,tt)
% -------------------------------------------------------------------------
%   Explanation :  
%           This function updates the target model (spectral pdfs) by
%           averaging with the assigned blob's model
% -------------------------------------------------------------------------
rows = round(bc(ID,2)-bc(ID,4)):round(bc(ID,2)+bc(ID,4));
cols = round(bc(ID,1)-bc(ID,3)):round(bc(ID,1)+bc(ID,3));

% Filter the background pixels
roiTemp = reshape(roi,size(roi,1)*size(roi,2),size(roi,3));
Indexes = find(Mask==0);
roiTemp(Indexes,:) = 0;
roi = reshape(roiTemp,size(roi,1),size(roi,2),size(roi,3));

% Compute HSI Feature Vector for Each Band Subset
inc = 6/ml.N_LMaps;
Band_Ind = 5;
Bands = 1:Band_Ind:30;
Inc_Index = 5;
for i = 1:ml.N_LMaps
   for j = 1:3
   	[sphist]=feval([ml.Feature_Extraction],roi(rows,cols,Bands(inc*i-(inc-1)):Inc_Index:Bands(inc*i)));
        hist.reference_first{j,i} =  (0.9 * hist.reference_first{j,i} + 0.1 * sphist);
   end
end
