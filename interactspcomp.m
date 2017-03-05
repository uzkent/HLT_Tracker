function [score]=interactspcomp(sp_blob_1,sp_blob_2)
%% THIS FUNCTION INTERACTIVELY COMPARES SPECTRA COLLECTED AT TWO LOCATION
% gray1=sum(data,3);
% imshow(gray1,[0 max(max(gray1))]); % Ask the user to pick a target from the frame
% zoom on;
% waitfor(gcf,'CurrentCharacter',13);
% zoom reset
% zoom off
% [x,y]=ginput(2);     % User pick a target 
% SP_1 = reshape(data(ceil(y(1)),ceil(x(1)),:),61,1);
% SP_2 = reshape(data(ceil(y(2)),ceil(x(2)),:),61,1);
hist_1 = SpectralHoG(sp_blob_1);
hist_2 = SpectralHoG(sp_blob_2);
[score.sh]=pdist2(hist_1',hist_2','chisq'); % SAM distance

hist_1 = WeightedHistogram(sp_blob_1);
hist_2 = WeightedHistogram(sp_blob_2);

[score.wh]=pdist2(hist_1',hist_2','chisq'); % SAM distance

% figure
% plot(SP_1)
% hold on
% plot(SP_2,'r')
% result=samest(SP_1,SP_2);
