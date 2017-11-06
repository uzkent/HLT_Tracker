function [target,hist]=matchdetect(target,tm,ml,IF,bb)
%% THIS FUNCTION MATCHES A DETECTION WITH THE SELECTED TARGET TO INITIATE THE VELOCITIES AND ACCELERATIONS
% Compare candidates with the selected target or targets of interest
for j=1:size(target.user_y,1)
    
    % Center of the selected region
    mu = [bb(5),bb(4) - 250];
    
    for n = 1:3
        % ROI containing the target
        rows2=ceil(mu(2)-bb(6)):ceil(mu(2)+bb(6));
        cols2=ceil(mu(1)-bb(7)):ceil(mu(1)+bb(7));

        % Read the HSI image
        Im_1 = matfile(sprintf('/Volumes/Burak_HardDrive/Moving_Platform_HSI_NoTrees_2/Image_%d.mat',IF+tm+1));
        temp_sp2 = Im_1.img(rows2,cols2,:);
        temp_sp2 = NoiseAdd(temp_sp2,ml.NL);
        
        % Compute HSI Feature Vector for Each Band Subset
        Inc_Index = 5;
        for i = 1:ml.N_LMaps
            group_index = Inc_Index * (i - 1) + 1;
            [sphist]=feval([ml.Feature_Extraction],temp_sp2(:,:,group_index:Inc_Index:group_index+4));
            hist.reference_first{n,i} = sphist;
        end
    
    end
    target.detect{j} = [mu(1);mu(2);size(cols2,2)/2;size(rows2,2)/2;0;0];
    
    % Concatenate the histograms 
    hist.match_number{j} = 0;

end
