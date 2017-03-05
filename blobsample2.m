function [hist,Dist] = blobsample2(hist,bh,tt,j,tm,roi,ml)
%% THIS FUNCTION SAMPLES SPECTRAL DATA FROM THE DETECTED BLOBS
%==========================================================================
%   Explanation : 
%       This function samples detected blobs in order to identify them if
%       they are the target of interest or not. The blobs that are not
%       located within the gate is not sampled. Center of the blobs are
%       sample locations. 
%   Author : Burak Uzkent
%==========================================================================
mu = tt.mapped{j};        % Mean
hist.sampled = 0;         % Sample Indicator
hist.detect{tm} = [];
Dist = zeros(1,size(bh{tm},1));

[rw,cl,~] = size(roi);    % Dimensions of the ROI

boundary_row = ceil(mu(2)-tt.Kn_Thresh); % Sample the ROI
boundary_col = ceil(mu(1)-tt.Kn_Thresh); % Sample the ROI

% Iterate through each detected object
for i=1:size(bh{tm},1)
      
      % Sample the ROI
      bh{tm}(i,2) = ceil(bh{tm}(i,2)-boundary_row);
      bh{tm}(i,1) = ceil(bh{tm}(i,1)-boundary_col);

      % Sample along Columns and Rows
      cols = ceil(bh{tm}(i,1)-bh{tm}(i,3)):ceil(bh{tm}(i,1)+bh{tm}(i,3));
      rows = ceil(bh{tm}(i,2)-bh{tm}(i,4)):ceil(bh{tm}(i,2)+bh{tm}(i,4));

      rows = unique(max(min(rows,rw),1));  % Neglect Out of Frame pixels
      cols = unique(max(min(cols,cl),1));
      temp= roi(rows,cols,:);          % Collect Spectral Data

      % Collect the Spectral Histogram Features
      dim.x = 8; dim.y = 8;
      [sphist]=feval([ml.Feature_Extraction],temp,dim);
      hist.detect{tm}{i}=sphist;

      % Compute the distance
      [Dist(i)]=pdist2(sphist',hist.reference_first{j}','chisq'); % SAM distance
    
end

%% Update the Histogram and remove the unmatched histograms
[value,ind] = min(Dist);
[hist.MatchInd{j,tm}]=find(Dist<tt.Sp_Thresh);

if value < tt.Sp_Thresh
    hist.DIndex{tm}(j,1)=ind;           % Index Update for Target Features 
else
    hist.DIndex{tm}(j,1)=0;             % Index Update for Target Features   
end