function [Dist,hist]=FeatureMatching2(target,time,hist,j)
%% THIS FUNCTION PERFORMS FEATURE MATCHING
% =========================================================================
%   Explanation: 
%       This function matches features to reduce valjated measurements
%       within the gate. The features are extracted from blobs. To get the
%       best match, user selected features and the features collected in
%       the previous time step are compared to the features collected in
%       the current time step.
%   Author: Burak Uzkent
% =========================================================================
blob_num = size(hist.detect{time},2); 
Dist = ones(1,blob_num);  % Initiate Distance Arrays
 
%% If there is any sampled blob, perform matching
if hist.sampled == 1;
    % Generate the checkerboad matrix to ignore empty elements
    checkmatrix = cellfun('isempty',hist.detect{time});  
    
    if time > 2 
       
        if hist.DIndex{time-1}(j,1) ~= 0 % Had any match previously?
          
            ref_second = hist.reference_second{j}; 
       
        else ref_second = []; 
        
        end
        
    else ref_second = [];
    end
    
    ref_first = hist.reference_first{j}; % Reference feature from the first frame
    
    % Go through each detected blob
    for i=1:blob_num
        
        if checkmatrix(1,i) ~= 1            % Test vector is empty?
            
            test=hist.detect{time}{1,i};    % Test Vector Spectral
                        
            [Dist(i)]=pdist2(test',ref_first','chisq'); % SAM distance
            
            if isempty(ref_second) == 0    % Had any match previously?
               
                [score]=pdist2(test',ref_second','chisq'); % SAM distance
            
                Dist(i) = (Dist(i) + score)/2;
                
            end
            
        else Dist(i) = NaN;
        
        end
        
    end
    
    [Value,Index]=nanmin(Dist);   % Get the best match
    
    % If the match value is above the threshold, do not USE it
    if Value > target.Sp_Thresh
       Index = 0;
    else
       [hist]=spectraremove(hist,Index,2,time);         % Remove the unmatched ones
       hist.match_number{j} = hist.match_number{j} + 1; % Update the # of match times

       % Average the histograms for robustness
       hist.reference_second{j} = (hist.reference_second{j}*hist.match_number{j}+...
           hist.detect{time}{Index})/(hist.match_number{j}+1);
    
    end
    hist.DIndex{time}(j,1)=Index;           % Index Update for Target Features
    
else hist.DIndex{time}(j,1)=0; % Index Update for Target Features
end