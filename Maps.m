A = roi(12:end-11,12:end-11,:);
RGB_roi = cat(3,sum(A(:,:,21:2:30),3),sum(A(:,:,11:2:20),3),sum(A(:,:,1:2:10),3));
Dist_temp = Dist(12:end-11,12:end-11);
%Dist_temp(Dist_temp==100) = -10;
%maxim = max(max(Dist_temp));
%Dist_temp(Dist_temp==-10) = maxim;
seg = imquantize(Dist_temp,target.thresh);
seg = 255 * seg ./ max(max(seg));
RGB_Map = label2rgb(uint8(seg));
imshow(RGB_roi);
figure
imshow(RGB_Map);