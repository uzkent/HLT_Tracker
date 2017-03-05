% function [DoLP,AoP,S] = PolarizationInfo(Image)
% POLARIZATION COMPUTATIONS
% Read the polarized images
close all
figure
ImageList = dir('../Frames_Three_White_Cars_15pm_Polarization/*img');
Number_Images = numel(ImageList);
ImdataP = cell(1,numel(ImageList));
first = '/Users/burakuzkent/Desktop/Research/Tracking/Frames_Three_White_Cars_15pm_Polarization/';
second = ImageList(70).name;

% Read the Polarization Image
Image = enviread([first,second]);
Image = Image(315:708,174:746,:);

% Add Noise to the Image
[Image,PSNR] = NoiseAdd_2(Image);

% Extract the stokes vector images
count=1;
for i=2:4:size(Image,3)-2
    
    % Intensity Image
    S{1,count}=Image(:,:,i-1);

    % Polarized Linearly 
    S{2,count}=Image(:,:,i)./Image(:,:,i-1);
    
    % Polarized Linearly 45 degrees
    S{3,count}=Image(:,:,i+1)./Image(:,:,i-1);  
    
    % Polarized Circularly 90 degrees
    S{4,count}=Image(:,:,i+2)./Image(:,:,i-1);

%     count=count+1;
%     S{1,count}=0.5*(Image(:,:,i-1)+Image(:,:,i)+Image(:,:,i+1)+Image(:,:,i+2));
%     S{2,count}=Image(:,:,i-1)-Image(:,:,i+1);
%     S{3,count}=Image(:,:,i)-Image(:,:,i+2);  
%     S{4,count}=Image(:,:,i+2)./Image(:,:,i-1);
    count=count+1;
end

% Obtain DoLP and AoP images
for i=1:size(S,2)
    
    % Degree of Linear Polarization
    DoLP{1,i}=(sqrt(S{2,i}.^2+S{3,i}.^2))./S{1,i};

    % Angle of Linear Polarization
    AoP{1,i}=atan(S{3,i}./S{2,i});

end

% Display degree of linear polarization images for each channel
imshow(DoLP{1,1},[])