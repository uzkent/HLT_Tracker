function [target] = normpdf_2d(target,model,Weight,time)
% THIS FUNCTION DRAW THE PDF FOR THE CURRENT TIME STEP and ALSO DRAW THE
% CONTOUR PDF ON DIRSIG IMAGE
Sigbound=3; % Define the standart deviation for the distribution of components
max_x=target.mu_pred{time}{1,1}(1)+Sigbound*sqrt(target.sig_pred{time}{1,1}(5,5)); % Initiate the Max. X Coordinate
min_x=target.mu_pred{time}{1,1}(1)-Sigbound*sqrt(target.sig_pred{time}{1,1}(5,5)); % Initiate the Min. X Coordinate
max_y=target.mu_pred{time}{1,1}(2)+Sigbound*sqrt(target.sig_pred{time}{1,1}(6,6)); % Initiate the Max. Y Coordinate
min_y=target.mu_pred{time}{1,1}(2)-Sigbound*sqrt(target.sig_pred{time}{1,1}(6,6)); % Initiate the Min. Y Coordinate
for i=1:model.n
    xc=target.mu_pred{time}{1,i}(1); % Get the X coordinate
    yc=target.mu_pred{time}{1,i}(2);  % Get the Y coordinate
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
    
x1=[floor(min_x):1:ceil(max_x)];  % Define the x range
x2=[floor(min_y):1:ceil(max_y)];  % Define the y range
[X1,X2] = meshgrid(x1,x2);
F=0;    % Initiate the PDF parameter
% Accumulate the PDF
for i=1:37
    SigTemp=target.sig_pred{time}{1,i}(5:6,5:6);
    SigTemp(2,1)=SigTemp(1,2);
    Mu=target.mu_pred{time}{1,i}(1:2)';
    target.PriorPDF{time}{i}=mvnpdf([X1(:) X2(:)],[Mu(1) Mu(2)],SigTemp);
    F = F+target.PriorPDF{time}{i}*Weight.Measurement{time}(1,i);    % Find the PDF 
    %F_Cum = F_Cum+Weight.Measurement{time}(1,i)*mvncdf([X1(:) X2(:)],target.mu_pred{time}{1,i}(1:2)',target.sig_pred{time}{1,i}(5:6,5:6));
end
F = reshape(F,length(x2),length(x1));
%contour(x1,x2,F)    % Draw the PDF as contour plot on DIRSIG
%h=figure(2); 
%Fig=surf(x1,x2,F);      % Display the PDF
%set(Fig, 'edgecolor','none')
%hold on
%close(h)    % close the figure





