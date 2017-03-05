function [value,compID]=FeatureMatching(tm,hist,ml,rows)
%% THIS FUNCTIONS COMPUTES THE DISTANCE BETWEEN HISTOGRAMS
% dis=zeros(current_tm-1,ml.n);            % Initiate the similarity matrix

%% Compute the similarities between feature vectors
% Get the feature matrix from the first tm step
ref_first=hist.reference_first{rows};

% Get the Features from the Second Histogram
if tm > 2 
   
   if hist.DIndex{tm-1}(rows,1) ~= 0 % Had any match previously?
   
       ref_second = hist.reference_second{rows}; 
   
   else ref_second = []; 
   
   end
   
else ref_second = [];
end

for com=1:ml.n                     % Go through each Gaussian component
       
    % Get the new feature vector from a component 
    new_hist=hist.pred{rows,tm}{1,com};

    if isempty(new_hist)==0   % If the current vector is NOT empty,

        [dis(com)]=pdist2(new_hist',ref_first','chisq'); % Distance
        
        if isempty(ref_second)==0

            [score]=pdist2(new_hist',ref_second','chisq'); % Distance

            dis(com) = (dis(com) + score)/2;
            
        end
    else
        dis(com) = NaN;
    end
    
end
[value,compID] = nanmin(dis); % ID of the best match