%function [gate]=RG_TreeDetect(img2_HSI,pixel,target)
%%
tic
hsi=img2_HSI;
rgb=cat(3,hsi(:,:,26),hsi(:,:,16),hsi(:,:,6));
gray=rgb2gray(rgb);
indexes=find(pixel.veg_ID{time}==1);    % Vegetarian Terms
muall=cell2mat(target.mu_pred2{time});
muall=muall(:,indexes);
muf=mean(muall,2);
stdf=std(muall,0,2);
c=1;
for i=1:size(muall,2)
    if abs(muall(1,i)-muf(1))>stdf(1) || abs(muall(2,i)-muf(2))>stdf(2)
        ind(c)=i;
        c=c+1;
    end
end
%%
muallup=muall;
muallup(:,ind)=[];
mu=round(target.x_predic{time});
TP=15;          % Trim Percent
DN=20; UP=100;  % Frame Crop Parameters
Threshold=25;   % Region Growing Threshold
if abs(mu(5))>abs(mu(6))
    if (mu(5)>0)
        murows=mu(1)-DN:mu(1)+UP;
        mucols=mu(2)-DN:mu(2)+DN;
        mu(1)=mu(1)-DN;
        mu(2)=mu(2)-DN;
    else
        murows=mu(1)-UP:mu(1)+DN;
        mucols=mu(2)-DN:mu(2)+DN;
        mu(1)=mu(1)-UP;
        mu(2)=mu(2)-DN;
    end
else
    if (mu(6)>0)
        murows=mu(1)-DN:mu(1)+DN;
        mucols=mu(2)-DN:mu(2)+UP;
        mu(1)=mu(1)-DN;
        mu(2)=mu(2)-DN;
    else
        murows=mu(1)-DN:mu(1)+DN;
        mucols=mu(2)-UP:mu(2)+DN;
        mu(1)=mu(1)-DN;
        mu(2)=mu(2)-UP;
    end
end
%%
hsicrop=hsi(mucols,murows,:);
graycrop=gray(mucols,murows);
obj_x_d=0;obj_y_d=0;obj_x_u=0;obj_y_u=0; polyall=[];
count=0;
for i=1:size(muallup,2)
    x_1(i)=round(abs(muallup(1,i)-mu(1)));
    y_1(i)=round(abs(muallup(2,i)-mu(2)));
    spect=hsicrop(y_1(i),x_1(i),:);
    nvdi=(spect(42)-spect(22))./(spect(42)+spect(22));
    int=graycrop(y_1(i),x_1(i));
%     figure(1)
%     imshow(graycrop)
%     hold on
    if (y_1(i)<=size(graycrop,1) && x_1(i)<=size(graycrop,2)) && (x_1(i)>0 && y_1(i)>0) && nvdi>0.2 && int<0.2
        poly = regionGrowing(255*(graycrop), [y_1(i) x_1(i)], Threshold);
        if isempty(poly)==0
            obj_x_d(i)=min(poly(:,1));
            obj_x_u(i)=max(poly(:,1));
            obj_y_d(i)=min(poly(:,2));
            obj_y_u(i)=max(poly(:,2));
%             plot(x_1(i), y_1(i), 'ro','LineWidth', 5)
%             plot(poly(:,1), poly(:,2), 'LineWidth', 2)
%             pause
            count=count+1;
            polyall=[polyall;poly];
        end
    end
    %close all
end
% Eliminate some of them
% in=find(obj_x_d<1);
% in2=find(abs(obj_y_d-obj_y_u)<10);
% in=[in in2];
% obj_x_d(in)=[];
% obj_x_u(in)=[];
% obj_y_d(in)=[];
% obj_y_u(in)=[];
% XD=trimmean(obj_x_d,TP);
% XU=trimmean(obj_x_u,TP);
% YD=trimmean(obj_y_d,TP);
% YU=trimmean(obj_y_u,TP);
XD=min(polyall(:,1)-10);
XU=max(polyall(:,1)+10);
YD=min(polyall(:,2));
YU=max(polyall(:,2));
figure
imshow(graycrop)
hold on
plot(polyall(:,1), polyall(:,2), 'LineWidth', 2)
plot(x_1, y_1, 'ro','LineWidth', 5)
toc