%% Display the automatically initiated tracks to remove shadow-occluded ones
% Center of the selected region
% Read the text 
Dt = dlmread('Input_MoreSamples_WTrees.txt');   % Input Data
Stack = [];
for i = 1:size(Dt,1)
    % Mean Values
    mu = [Dt(i,4),Dt(i,5)];

    % ROI containing the target
    rows2=ceil(mu(2)-10):ceil(mu(2)+10-1);
    cols2=ceil(mu(1)-10):ceil(mu(1)+10-1);

    % Read the HSI image
    Im_1 = matfile(sprintf('../Scenario/Image_%d.mat',Dt(i,2)+1));
    %temp_sp2 = sum(Im_1.Image(rows2,cols2,:),3);
    temp_sp2 = cat(3,10^2*Im_1.Image(rows2,cols2,26),10^2*Im_1.Image(rows2,cols2,16)...
        ,10^2*Im_1.Image(rows2,cols2,6));
    Stack = [Stack temp_sp2];
end