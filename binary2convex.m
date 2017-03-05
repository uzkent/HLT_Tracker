function [tt,sDist,hist]=binary2convex(fMask,dMask,hist,tt,tm)
%% THIS FUNCTION GENERATES CONVEX HULL IMAGE FROM BINARY IMAGE 
[result, num] = bwlabel(fMask);     % Label detected ones
detect = zeros(num,5);              % Initiate the detection parameter
sDist = zeros(1,num);               % Initiate the detection parameter
Angle = regionprops(result,'orientation'); % Estimate the rotation angle of the object
% dMask(dMask>tt.Sp_Fthresh) = NaN;
dMask(dMask>1000) = NaN;

%% SEARCH FOR EACH DETECTION AND EXTRACT INFORMATION
for i=1:num
    
    % Find the coordinates of the detected object    
    [x,y]=find(result==i);
    X=[y';x'];
    
    % Find thenlengtsnans width of the object
    if (size(X,2) < 25) || (size(X,2) > 500)
        continue
    end
    bb=minBoundingBox(X);

    dis=zeros(4,4);
    for j=1:4
        for n=1:4
            dis(j,n)=sqrt((bb(1,j)-bb(1,n))^2+(bb(2,j)-bb(2,n))^2);
        end
        dis(dis==max(max(dis)))=NaN; % Delete the diagonal distance
    end
    dis(dis==0) = NaN;             % Delete pixels with 0's      
    [Width]=nanmin(nanmin(dis));   % Get the width
    [Length]=max(max(dis));        % Get the length
    Center(1)=mean(X(1,:));        % Estimate the X coordinates of the center
    Center(2)=mean(X(2,:));        % Estimate the Y coordinates of the center
    
    detect(i,:)=[Center(1),Center(2),Length/2,Width/2,Angle(i).Orientation];
    if (Length < 5 || Width < 5) || (Length > 25 || Width > 25)
       continue 
    end
    % Spectral Distance of the blob
    sDist(i) = nanmean(nanmean(dMask(x,y)));
    
end

% Remove the empty detection arrays
[indx,~] = find(detect(:,1)==0);
detect(indx,:)=[];
sDist(indx) = [];
tt.wholedetect{tm+1}=detect;  

%% Update the Histogram and remove the unmatched histograms
[value,ind] = min(sDist);
s = size(tt.Sp_Fthresh,2);
if value < tt.Sp_Fthresh{s}
    hist.DIndex{tm}(1,1)=ind;           % Index Update for Target Features 
else
    hist.DIndex{tm}(1,1)=0;             % Index Update for Target Features   
end
