clear;
first = '/Users/burakuzkent/Desktop/Truth/';
files = dir( fullfile(first,'*img') );
files = {files.name}';
files = sort_nat(files);
first2 = '/Users/burakuzkent/Desktop/Truth_Updated/';
% figure(1);
% hold on;
% Panchromatic = cell(1,32);
% c = 138;
% figure(1);
for i= 1:230
    full = [first files{i}];
    full2 = [first2 files{i}];
    [FullImage,Info] = enviread(full);
    MoonShadowMap = FullImage(:,:,3);
    MoonShadowMap(MoonShadowMap~=1) = 0;
    SunShadowMap = FullImage(:,:,2);
    SunShadowMap(SunShadowMap==0) = -1;
    SunShadowMap(SunShadowMap==1) = 0;
    SunShadowMap(SunShadowMap==-1) = 1;
    VehicleMap = FullImage(:,:,1);
    VehicleMap(VehicleMap<0) = 0;
    VehicleMap = VehicleMap .* SunShadowMap .* MoonShadowMap; % Refined Vehicle Map
    VehicleMap(VehicleMap<5000)=0;
    VehicleMap(VehicleMap>6000)=0;
    [result,num] = bwlabel(VehicleMap);
    for j = 1:num
        [ind] = find(result==j);
        ind2 = VehicleMap(ind(end));
        [ind] = find(VehicleMap==ind2);
        size(ind,1)
        if size(ind,1) < 50 || size(ind,1) > 200
            VehicleMap(VehicleMap==ind2) = 0;
        end
    end
    VehicleMap(VehicleMap==0) = -1;
    FullImage(:,:,1) = VehicleMap;
    % imshow(FullImage(:,:,1),[])
    % hold on
    % imshow(VehicleMap);
    enviwrite(FullImage,Info,[full2],[full2 '.hdr']);
    % Panchromatic{i+14} = sum(Image(:,:,1:30),3);
    % saveimage(Image,c);
    % c = c + 1;
    % load(sprintf('/VOLUMES/MY BOOK/FR_07_Circling_12pm/Full/Image_%d.mat',i));
    % Panchromatic{i-118} = sum(Image(:,:,1:30),3);
    % Image = h5read(sprintf('/Users/burakuzkent/Desktop/Research/Tracking/CirclingFlight_Scenario/Image_%d',i-1), '/Data');
%     [Image] = imageregister(Image,ml,i);
%     Panchromatic{i} = sum(Image,3);
%     S = 10^4 * S(1:200,1:200,:);            % Sensor Reaching Radiance
%     S = S./G;                               % Camera Equation
%     S = S.*factor;                          % Irradiance to Voltage Conversion
%     Vsat = 0.95*(max(max(max(abs(S)))));    % Maximum signal level
%     sigma2 = sqrt(abs(S)).* A;
%     Nphi = (randn(size(sigma)).*sigma2 + mu);
%     Image = ((2^b*(max(min(S+Nphi+Nro,Vsat),0))/(Vsat))+0.5)*2^-b; 
    % h5create(sprintf('/Users/burakuzkent/Desktop/Research/Tracking/CirclingFlight_Scenario_Regd/Image_%d',i-1), '/Data',[1200,800,61]);
    % h5write(sprintf('/Users/burakuzkent/Desktop/Research/Tracking/CirclingFlight_Scenario_Regd/Image_%d',i-1), '/Data', Image);
end

% clearvars -except Panchromatic
% first = '/Users/burakuzkent/Desktop/Fixed_Tracking/HSI/';
% files = dir( fullfile(first,'*img') );
% files = {files.name}';
% files = sort_nat(files);
% c = 1;
% for i= 101:110
%     full = [first files{i}];
%     [Image] = enviread(full);
%     Panchromatic{i}=255*sum(Image(:,:,1:30),3) ./ max(max(sum(Image(:,:,1:30),3)));
%     saveimage(Image,i);
%     c = c+1;
% end