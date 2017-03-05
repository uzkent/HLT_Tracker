function drawRectangleonImageAtAngle(blob)
% To draw a rectangle at a given pixel location (center) with any width and
% height rotated at an angle
% Input: 
% img - image (gray scale or color)
% center - the pixel location of the center of rectangle 2x1 vector
% width - width of rectangle in pixels
% height - height of rectangle in pixels
% angle - rotation angle of rectangle in degrees
% output: 
% hdl = handle to figure

% Sudarshan Ramenahalli, Johns Hopkins University (sudarshan@jhu.edu)
center = [blob(1);blob(2)];
width = 2*blob(3);
height = 2*blob(4);
theta = blob(5)*(pi/180);
coords = [center(1)-(width/2) center(1)-(width/2) center(1)+(width/2)  center(1)+(width/2);...
          center(2)-(height/2) center(2)+(height/2) center(2)+(height/2)  center(2)-(height/2)];
R = [cos(theta) sin(theta);...
    -sin(theta) cos(theta)];
rot_coords = R*(coords-repmat(center,[1 4]))+repmat(center,[1 4]);
rot_coords(:,5)=rot_coords(:,1);
line(rot_coords(1,:),rot_coords(2,:),'LineWidth',1.5);
