%% THIS FUNCTION COLLECTS TRAINING DATA FOR VEHICLE VS. NON-VEHICLE 
% DETECTION.
% User selects a bounding box and hyperspectral information for the
% corresponding region is extracted and transferred to a global array.

% Display the Image
close all
index = 71;
id = 47;
string = 'Image 6';
Label = 'Positive';
fid = fopen('/Users/burakuzkent/Desktop/Research/Tracking/Ground_Truth/46.txt','a');
% imshow(sum(Image{1}(:,:,1:30),3))
imshow(Panchromatic{id+ct})
% HSI Image
% Im_1 = matfile(sprintf('../CirclingFlight_Scenario_HR/Image_%d.mat',index)); 

% Zoom on the car or non-vehicle detection
% Select a bounding box
x = input('There is target or not Y/N');
ct = ct+1;
% x = 1;
if x == 1;
%     zoom on;
%     waitfor(gcf,'CurrentCharacter',13);
%     zoom reset
%     zoom off
    [c,r] = ginput(1);
    set(gca, 'XLim', [c-75, c+75], 'YLim', [r-75, r+75])
    Cr = getrect;
    c = Cr(1);  r = Cr(2);

    % Indexes for the samples
    cols = ceil(Cr(1)):ceil(Cr(1)+Cr(3));
    rows = ceil(Cr(2)):ceil(Cr(2)+Cr(4));
    
else
    Cr = [NaN, NaN, NaN, NaN];
end

%% Write the information of the selection to a text file
fprintf(fid,'%d|%d|%d|%d\n',ceil(Cr(1)),ceil(Cr(2)),ceil(Cr(3)),ceil(Cr(4)));
TrainingData_Car_NonCar

% USE GINPUT FOR NEGATIVES - Randomly change central coordinates while
% keeping the dimensions same

%% Collect the spectral data
% offset = 10;
% for j = counter:counter+39
%     rs_1 = randi([rows(1)-offset rows(1)+offset]);
%     rs_F = randi([rows(end)-offset rows(end)+offset]);
%     cs_1 = randi([cols(1)-offset cols(1)+offset]);
%     cs_F = randi([cols(end)-offset cols(end)+offset]);
%     xx = randi([15 20]);
%     yy = randi([15 20]);
%     Negatives{j} = Image{id}(rs_1:rs_1+xx,cs_1:cs_1+yy,:); 
% end
% counter = counter + 50;

%% Write the information of the selection to a text file
% fprintf(fid,'%d|%d|%d|%d|%s - %s\n',ceil(Cr(1)),ceil(Cr(2)),ceil(Cr(3)),ceil(Cr(4)),string,Label);