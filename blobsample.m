function [hist,bh,min_score] = blobsample(hist,bh,tt,j,tm,roi)
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
min_score = nan(1,size(bh{tm},1));
      
% Sample the ROI
boundary_row = ceil(mu(2)-tt.Kn_Thresh);
boundary_col = ceil(mu(1)-tt.Kn_Thresh);

% Iterate through each detected object
for i=1:size(bh{tm},1)
    if bh{tm}(i,1)~=0
        C(i) = sqrt((mu(1)-bh{tm}(i,1))^2+(mu(2)-bh{tm}(i,2))^2);   % Cost
    else 
        C(i) = 1000;
    end
    % Sample ONLY if it is within the gate 
    if C(i) < sqrt(2*tt.Kn_Thresh^2) 
      
      % Sample along Columns and Rows
      central_c = ceil(bh{tm}(i,1)-boundary_col);
      central_r = ceil(bh{tm}(i,2)-boundary_row);

      cols1 = min(max(central_c-10,1),2*tt.Kn_Thresh);
      cols2 = min(max(central_c+9,1),2*tt.Kn_Thresh);
      cols = cols1:cols2;
      rows1 = min(max(central_r-10,1),2*tt.Kn_Thresh);
      rows2 = min(max(central_r+9,1),2*tt.Kn_Thresh);
      rows = rows1:rows2;

      % Sample the blob in the current imagery
      temp = roi(rows,cols,:);      
      
      %% 1st Level Classifier - NDVI based Vegetation Pixel classifier
      NIR = temp(:,:,43);
      VIS = temp(:,:,23);
      Score = (NIR - VIS) ./ (NIR + VIS);
      Score( Score>0.2 )=50;
      
      %% Compute Integral Histograms for each bin
      [Histograms] = IntegralHistogram(temp);
      Col_Size = 3;
      Row_Size = 3;
      min_score(i) = 50;
      
      % Sliding Window Approach
      for rs = Row_Size+1:size(temp,1)-Row_Size  
            
          for cs = Col_Size+1:size(temp,2)-Col_Size
                
              if Score(rs,cs) ~= 50
                    
                  % Compute the histogram
                  Row_Samples = rs-Row_Size:rs+Row_Size;
                  Col_Samples = cs-Col_Size:cs+Col_Size;
                  [temphist] = ComputeHistogram2(Histograms,Row_Samples,Col_Samples);
                    
                  % Compute the distance
                  [Dist]=pdist2(temphist',hist.reference_first{j}','chisq'); % SAM distance
                    
                  % Update the index for the better match
                  if Dist < min_score(i)
                      min_score(i) = Dist;
                      sphist = temphist;
                      c_x = rs;
                      c_y = cs;
                  end
                  
              end
              
          end
          
      end
      hist.sampled = 1; 
      
      % Update the Detected Movements List
      if min_score(i) < tt.Sp_Thresh
          bh{tm}(i,1) = boundary_col + cols(1) + c_y;      % Detected Vehicle Coordinates
          bh{tm}(i,2) = boundary_row + rows(1) + c_x;
          bh{tm}(i,3) = 4;
          bh{tm}(i,4) = 4;
          hist.detect{tm}{i}=sphist;        % Transfer to a global variable
          % plot(bh{tm}(i,1),bh{tm}(i,2),'o','Linewidth',1,'MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',5);
      end
    end
end

%% Update the Histogram and remove the unmatched histograms
[value,ind] = min(min_score);
[hist.MatchInd{j,tm}]=find(min_score<tt.Sp_Thresh);

if value < tt.Sp_Thresh
    hist.DIndex{tm}(j,1)=ind;           % Index Update for Target Features
    
    % Update the histogram
    % hist.match_number{j} = hist.match_number{j} + 1; % Update the # of match times
    
    % Average the histograms for robustness
    % hist.reference_first{j} = (hist.reference_first{j}*hist.match_number{j}+...
    %    hist.detect{tm}{ind})/(hist.match_number{j}+1);
     
else
    hist.DIndex{tm}(j,1)=0;             % Index Update for Target Features   
end