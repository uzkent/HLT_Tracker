function [Mask] = svmHoG(Mask,ml,roi,Centers)
% -------------------------------------------------------------------------
%   Explanation : 
%           This function detects vehicle pixels on the given mask. The
%           feature descriptor is the Histogram of Oriented Gradients and
%           linear SVM is used to classify pixels.
% -------------------------------------------------------------------------
%% Sliding Window Approach - HoG Car Detector
Windows = 5;
In = 1;
Test_Data2 = ones(size(Centers,1)*(Windows+1),1764);
for i = 1:size(Centers,1)
      
      %% Area Thresholding
      if (Centers(i).BoundingBox(3) < 25 && Centers(i).BoundingBox(4) < 25) ...
              && (Centers(i).BoundingBox(3) * Centers(i).BoundingBox(4) > 25)
          
          %% Try different size detection windows
          for wn = In:In+Windows
              
              %% Compute the Histogram
              Row_Samples = ceil(Centers(i).BoundingBox(2)-wn):ceil(Centers(i).BoundingBox(2)+Centers(i).BoundingBox(4)+wn);
              Col_Samples = ceil(Centers(i).BoundingBox(1)-wn):ceil(Centers(i).BoundingBox(1)+Centers(i).BoundingBox(3)+wn);

              %% Compute the HoG Descriptor
              Temp = roi(Row_Samples,Col_Samples,:);
              Im = sum(Temp(:,:,1:2:30),3);
              Im = imresize(Im,[64,64]);
              tic
              Test_Data2((i-1)*(Windows+1)+(wn-In+1),:) = HoG(Im);
              toc
          end
          
      end
      
end

%% Classify It - Linear SVM Approach - a Single HoG Feature set
tic
[Labels,~,~] = svmpredict(ones(size(Test_Data2,1),1),double(Test_Data2), ml.CD_SVM2,'-q -b 1');
toc
Ls = [];
counter = 0;
for i = 1:(Windows+1):size(Labels,1)
    counter = counter + 1;
    Ls(counter) = sum(Labels(i:i+Windows));
end
if isempty(Ls)==0
    
    Indexes = find(Ls < -2);
    for i = 1:size(Indexes,2)
        Mask(Mask==Indexes(i))=0;
    end
    
end
Mask(Mask~=0)=1;
