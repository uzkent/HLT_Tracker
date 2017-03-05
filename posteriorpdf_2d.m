function [target] = posteriorpdf_2d(target,model,Weight,time)
% --------------------------------------------------------------------------------------------------
% THIS FUNCTION DRAW THE POSTERIOR PDF FOR THE CURRENT TIME STEP and ALSO DRAW THE CONTOUR PDF ON DIRSIG IMAGE
% --------------------------------------------------------------------------------------------------
Sigbound=3; % Define the standart deviation for the distribution of components
max_x=target.mu{time}{1,1}(1)+Sigbound*sqrt(target.sig{1,1}(5,5)); % Initiate the Max. X Coordinate
min_x=target.mu{time}{1,1}(1)-Sigbound*sqrt(target.sig{1,1}(5,5)); % Initiate the Min. X Coordinate
max_y=target.mu{time}{1,1}(2)+Sigbound*sqrt(target.sig{1,1}(6,6)); % Initiate the Max. Y Coordinate
min_y=target.mu{time}{1,1}(2)-Sigbound*sqrt(target.sig{1,1}(6,6)); % Initiate the Min. Y Coordinate
for i=1:model.n
    xc=target.mu{time}{1,i}(1); % Get the X coordinate
    yc=target.mu{time}{1,i}(2);  % Get the Y coordinate
    if xc>max_x;        % Update the maximum X ccordinate
       max_x=xc;
    end
    if min_x>xc;        % Update the minimum X coordinate
       min_x=xc;
    end
    if yc>max_y         % Update the maximum Y coordinate
       max_y=yc;
    end      
    if yc<min_y         % Update the minimum Y coordinate
       min_y=yc;
    end  
end
min_x1=floor(min_x);
max_x1=ceil(max_x);
min_x2=floor(min_y);
max_x2=ceil(max_y);
x1=[min_x1:(max_x1-min_x1)/100:max_x1];  % Define the x range
x2=[min_x2:(max_x2-min_x2)/100:max_x2];  % Define the y range
[X1,X2] = meshgrid(x1,x2);
target.F{time}=0;    % Initiate the PDF parameter
% Accumulate the PDF
for i=1:model.n
    SigTemp = target.sig{1,i}(5:6,5:6);
    SigTemp(2,1) = SigTemp(1,2);
    Mu = target.mu{time}{1,i}(1:2)';
    target.PosteriorPDF{time}{i} = mvnpdf([X1(:) X2(:)],[Mu(1) Mu(2)],SigTemp);
    % Individual PDFS
    P{i}=reshape(target.PosteriorPDF{time}{i},length(x2),length(x1));
    target.F{time} = target.F{time} + P{i}*Weight.Measurement{time}(1,i);    % Find the PDF 
    %F_Cum = F_Cum+Weight.Measurement{time}(1,i)*mvncdf([X1(:) X2(:)],target.mu{time}{1,i}(1:2)',target.sig{time}{1,i}(5:6,5:6));
end
target.F{time} = reshape(target.F{time},length(x2),length(x1));
% contour(x1,x2,F)    % Draw the PDF as contour plot on DIRSIG
% h=figure(2); 
% Fig=surf(x1,x2,target.F);      % Display the PDF
% set(Fig, 'edgecolor','none')
% hold on
% close(h)    % close the figure





