% % clear;
% first = '/Volumes/BURAK_USB/110515_120546/';
% second = 'lwir_';
% for i = 641:904
%     % for j = 1:5
%         Image = enviread([first second num2str(i) '.img']...
%             ,[first second num2str(i) '.hdr']);
%         %Image = flipud(Image);
%         %Image = fliplr(Image);
%         Image = 255 * Image / max(max(Image));
%         %Image2(:,:,j) = Image;
%     % end
%     %Image2 = reshape(Image2,494,648*5);
%     imwrite(uint8(Image),sprintf(...
%         ['/Users/burakuzkent/Desktop/Research/MultiSpectral_Tracking/WASP_Datasets3/Data_1_IR_Registered/Image_' num2str(i) '.png']));
%     %Image2 = [];
% end

clear;
first = '/Volumes/BURAK_USB/110515_120546/';
second = 'Pan_Camera_';
second2 = 'Camera';
second3 = 'lwir_';
close all;
% Open a video
Vid = VideoWriter(['CarIR' num2str(1) '.avi'],'Uncompressed AVI');
Vid.FrameRate = 4;
open(Vid);
figure(1);
% set(h, 'Position', [-0.2, 0.0, 1300, 1000]);
for i = 449:640
    Image = imread(sprintf(...
    ['/Users/burakuzkent/Desktop/Research/MultiSpectral_Tracking/WASP_Datasets3/Data_2_IR_Registered/Image_' num2str(i) '.png']));
%    Image2 = Image;
%     Image = imread(sprintf(...
%         ['/Users/burakuzkent/Desktop/Research/MultiSpectral_Tracking/WASP_Datasets3/Data_2_Pan_Registered/Image_' num2str(i) '.png']));
%     ImageIR = enviread([first second3 num2str(i) '.img']...
%         ,[first second3 num2str(i) '.hdr']);
%    Image = 255 * Image / max(max(Image));
%    axes('Position', [-0.07, 0.52, 0.45, 0.45]);
    imshow(Image,[]);
    hold on;
%     title('Panchromatic Image','Fontsize',12,'Color','r');
%     axes('Position', [0.24, 0.52, 0.45, 0.45]);
%     imshow(Image2(:,648*0+1:648*1),[]);
%     title('Red Light (632 nm)','Fontsize',12,'Color','r');
%     axes('Position', [0.55, 0.52, 0.45, 0.45]);
%     imshow(Image2(:,648*1+1:648*2),[]);
%     title('Green Light (550 nm)','Fontsize',12,'Color','r');
%     axes('Position', [-0.07, 0.03, 0.45, 0.45]);
%     imshow(Image2(:,648*2+1:648*3),[]);
%     title('NIR Light (800 nm)','Fontsize',12,'Color','r');
%     axes('Position', [0.24, 0.03, 0.45, 0.45]);
%     imshow(Image2(:,648*3+1:648*4),[]);
%     title('Red Light (650 nm)','Fontsize',12,'Color','r');
%     axes('Position', [0.55, 0.03, 0.45, 0.45]);
%     imshow(Image2(:,648*4+1:648*5),[]);
%     title('Blue Light (480 nm)','Fontsize',12,'Color','r');
%     Image2 = reshape(Image2,494,648*5);
    frame = getframe;
    writeVideo(Vid,frame);
%     imwrite(uint8(Image2),sprintf(...
%         ['/Users/burakuzkent/Desktop/Research/MultiSpectral_Tracking/WASP_Datasets3/Data_1_MS_Registered/Image_' num2str(i) '.png']));
%     imwrite(uint8(Image),sprintf(...
%         ['/Users/burakuzkent/Desktop/Research/MultiSpectral_Tracking/WASP_Datasets3/Data_1_Pan_Registered/Image_' num2str(i) '.png']));
%    Image2 = [];
end
close(Vid);