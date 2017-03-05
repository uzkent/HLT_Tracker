function [Detections] = HoGSearchROI(roi,HSIMask,ml)
bins=9;                             % Number of bins
interval=linspace(-180,180,bins);   % Intervals
data=sum(roi(:,:,1:2:30),3);        % Sum through all bands
[rows,cols]=size(data);
ginthist=zeros(rows,cols,bins);

% Pad the image with zeros
data = padarray(data,[1,1]);

% Create the operators for computing image derivative at every pixel.
hx = [-1,0,1];
hy = hx';

% Compute the derivative in the x and y direction for every pixel.
dx = imfilter(double(data), hx);
dy = imfilter(double(data), hy);

% Remove the 1 pixel border.
dx = dx(2 : (size(dx, 1) - 1), 2 : (size(dx, 2) - 1));
dy = dy(2 : (size(dy, 1) - 1), 2 : (size(dy, 2) - 1)); 

% Convert the gradient vectors to polar coordinates (angle and magnitude).
phase = atan2d(dy, dx);
mag = sqrt((dy.^2) + (dx.^2));

%% Compute the contribution of each pixel in the corresponding bin
ginthist = GradIntegralImage(interval,phase,mag,ginthist);

%% Compute integral images for each bin Image
ginthist=cumsum(cumsum(ginthist,2)); % integral image for each bin
ginthist = padarray(ginthist,[1,1]);
w = ml.HoG_SVM.weight;
b = ml.HoG_SVM.bias;

DMap = SlidingWindowHoGSVM(w,b,ginthist);
DMap = DMap .* HSIMask;
counter = 1;
Boxes = [];
for rs = 17 : 1 : size(roi,1) - 17
    for cs = 17 : 1 : size(roi,2) - 17
        if DMap(rs,cs) > 0.25
            Boxes(counter,:) = [rs-16,cs-16,rs+15,cs+15,DMap(rs,cs)];
            counter = counter + 1;
        end
        
    end
end

if isempty(Boxes) == 0;
    Boxes_Refined = nms(Boxes,0.5);
    Detections = [(Boxes_Refined(:,2)+Boxes_Refined(:,4))/2,(Boxes_Refined(:,1)+Boxes_Refined(:,3))/2,10*ones(size(Boxes_Refined,1),1)...
        ,10*ones(size(Boxes_Refined,1),1)];
else
    Detections = [];
end
