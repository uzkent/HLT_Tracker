function [pr_curve]=rmse_tp(target)
% ------------------------------------------------------------------------
%  Explanation :
%       This function evaluates the performance of the algorithm by
%       considering the Root Mean Square Error and Track Purity Metrics.
%       This function is only valid for single target tracking cases.
%   Author  : Burak Uzkent
% ------------------------------------------------------------------------
%Read the Ground Truth File
voiGT = dlmread(['/Volumes/Burak_HardDrive/Moving_Platform_HSI/Ground_Truth/Ground_Truth_Files/' num2str(target.id) '_track.txt']);
results = target.results;
%Initiate Precision Curve
pr_curve = zeros(1,50);

%Iterate GT
validFrame = 0;
for i = 1:size(results,1)

    index = find(voiGT(:,1)==results(i,3));
    
    if index
        %Compute Euclidean Distance
        dist(i) = sqrt(((results(i,2) - voiGT(index,2))^2+((results(i,1) - voiGT(index,3)+250)^2)));

        %Compute Precision
        for j = 1:50

           if (dist(i) <= j)
               pr_curve(j) = pr_curve(j) + 1;
           end

        end
        validFrame = validFrame + 1;
    end

end
%Normalize Precision Curve
pr_curve = pr_curve / validFrame;

%Print Run-Time Performance
pr_curve = [pr_curve mean(dist) mean(results(:,4))];