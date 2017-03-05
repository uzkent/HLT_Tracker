function []=displaytrack(x,~,ID,as,ml)
%% THIS FUNCTION DISPLAYS THE TRACK ON THE FRAME
if x(1)+abs(x(3))>ml.im_res(2)
    x(1) = ml.im_res(2)-1;
    x(3:4) = 0.1;
end
if x(2)+abs(x(4))>ml.im_res(1)
    x(2) = ml.im_res(1)-1;
    x(3:4) = 0.1;
end
if as ~= 0;
    plot(x(1),x(2),'ro','LineWidth',2);
else
   plot(x(1),x(2),'go','LineWidth',2);
end
% Display the index of the tracked car
text(x(1)-20,x(2)-20,num2str(ID),'fontsize',5,'BackgroundColor','g');

% writerObj = VideoWriter('YellowVehicle.avi');
% writerObj.FrameRate = 2;
% writerObj.Quality = 100;
% open(writerObj);
% frame = getframe;
% writeVideo(writerObj,frame);

%     subplot(1,2,2);
%     RGB = cat(3,sum(roi.sp(:,:,21:2:30),3),sum(roi.sp(:,:,11:2:20),3),sum(roi.sp(:,:,1:2:10),3)); 
%     imshow(RGB); hold on;
%     for in = 1:size(blobhist{time},1)
%          drawRectangleonImageAtAngle(blob(in,:));            
%     end
%     hold off;