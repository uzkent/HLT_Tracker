function [Mask] = roadClassifier(mVeg,roi,ml)
% -------------------------------------------------------------------------
%   Explanation :
%       This function classifies the roi pixels as road and nonroad pixels
%       using spectral profile of the roi
% -------------------------------------------------------------------------
mVeg(12:end-11,12:end-11) = mVeg(12:end-11,12:end-11) + 100;
mVeg(mVeg<100) = 0;
mVeg(12:end-11,12:end-11) = mVeg(12:end-11,12:end-11) - 100;
roi_temp = reshape(roi,size(roi,1)*size(roi,2),size(roi,3));
Mask_Temp = reshape(mVeg,size(mVeg,1)*size(mVeg,2),1);
Indexes = find(Mask_Temp>0);
test_data = roi_temp(Indexes,1:2:61);
%[~,~,Labels] = svmpredict(ones(size(Indexes,1),1),50*test_data, ml.RD_SVM,'-q -b 1');
%Labels(:,2) = [];
%Labels(Labels<=0.95) = -1;
%Labels(Labels>0.95) = 1;
Mask_Temp(Indexes) = -1 * -1;
Mask = mVeg + reshape(Mask_Temp,size(mVeg,1),size(mVeg,2));
