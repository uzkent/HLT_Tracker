function []=displayzoomtrack(x,ID,ml,im)
%% THIS FUNCTION DISPLAYS THE TRACK ON THE FRAME
% Estimate the orientation angle
% The display features for tracked cars
width = 100;
rows = min(max(x(2)-width,1),ml.im_res(1)):min(max(x(2)+width,1),ml.im_res(1));
cols = min(max(x(1)-width,1),ml.im_res(2)):min(max(x(1)+width,1),ml.im_res(2));
x(1) = width;
x(2) = width;
im = im(ceil(rows),ceil(cols));
subplot(1,2,2);
imshow(im,[]);
hold on
theta=atan(x(6)/x(5));               
if abs(x(3))>abs(x(4))
   DrawRectangle([x(1),x(2),2*abs(x(3)),2*abs(x(4)),-theta],'r-');
else
   DrawRectangle([x(1),x(2),2*abs(x(4)),2*abs(x(3)),-theta],'r-');  
end
% Display the index of the tracked car
% text(x(1)-20,x(2)-20,num2str(ID),'fontsize',5,'BackgroundColor','g');
hold off