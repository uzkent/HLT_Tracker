function [hist] = updateSpdfs(bc,roi,hist,ID,Mask,ml)
% -------------------------------------------------------------------------
%   Explanation :  
%           This function updates the target model (spectral pdfs) by
%           averaging with the assigned blob's model
% -------------------------------------------------------------------------
rows = round(bc(ID,2)-bc(ID,4)):round(bc(ID,2)+bc(ID,4));
cols = round(bc(ID,1)-bc(ID,3)):round(bc(ID,1)+bc(ID,3));
rows,cols
% Filter the background pixels
roiTemp = reshape(roi,size(roi,1)*size(roi,2),size(roi,3));
Indexes = find(Mask==0);
roiTemp(Indexes,:) = 0;
roi = reshape(roiTemp,size(roi,1),size(roi,2),size(roi,3));

% Compute the spectral pdfs
for i = 0:11
    for j = 1:3
    	% rows = bc(ID,2)-ml.dims{j}(1):bc(ID,2)+ml.dims{j}(1)-1;
    	% cols = bc(ID,1)-ml.dims{j}(2):bc(ID,1)+ml.dims{j}(2)-1;
    	Spdfs = WeightedHistogram(roi(rows,cols,i*5+1:i*5+5));
    	hist.reference_first{j,i+1} =  (0.75 * hist.reference_first{j,i+1} + 0.25 * Spdfs);
    end
end
