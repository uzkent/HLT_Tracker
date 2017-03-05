function h = DrawRectangle(blob)
%--------------------------------------------------------------------------
% H = DRAWRECTANGLE(PARAM,STYLE)
% This function draws a rectangle with the given parameters:
% - inputs:
%          param................... 1x5 array
%          - param = [a, b, w, h, theta]
%          - (a,b): the center of the rectangle
%          - (w,h): width and height of the rectangle > 0
%          - theta: the rotation angle of the rectangle
%          style................... string
%          - plot style string
% - output:
%          h....................... plot handler
%
%   Usage Examples,
%
%   DrawRectangle([0 0 1 1 0]); 
%   DrawRectangle([-1,2,3,5,3.1415/6],'r-');
%   h = DrawRectangle([0,1,2,4,3.1415/3],'--');
%
%   Rasoul Mojtahedzadeh (mojtahedzadeh _a_ gmail com)
%   Version 1.00
%   November, 2011
%--------------------------------------------------------------------------
x = blob(1) - blob(3);
y = blob(2) - blob(4);
alpha = 15;

vert_x = [x x+2*blob(3) x+2*blob(3) x x];
vert_y = [y y y+2*blob(4) y+2*blob(4) y];

R(1,:) = vert_x;
R(2,:) = vert_y;

Rot_Rect = [cosd(alpha) -sind(alpha);sind(alpha) cosd(alpha)]*R;
plot(Rot_Rect(1,:),Rot_Rect(2,:),'r');