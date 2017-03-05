function [metric]=rmse_tp(target,Dt,id,blobs,roi)
% ------------------------------------------------------------------------
%  Explanation :
%       This function evaluates the performance of the algorithm by
%       considering the Root Mean Square Error and Track Purity Metrics.
%       This function is only valid for single target tracking cases.
%   Author  : Burak Uzkent
% ------------------------------------------------------------------------
%% Read the actual positions of the TOI
first = '../Scenario1/';
second = Dt(id,1);
IF = Dt(id,2)+1;
nFrames = Dt(id,2)+20 - IF+1;
fid = fopen([first,num2str(second),'_track.txt'],'r');

%% Read data (coordinates of the TOI)
C_data = textscan(fid, '%s %d %d');
for i = 1:size(C_data{1},1)
    % Initial time of appearance
    toa(i) = str2double([C_data{1}{i}(19) C_data{1}{i}(20) C_data{1}{i}(21)]); 
end
firstF = find(toa == IF+1);

%% Calculate the Track Purity and Current Assignment Ratio Metric
TrackPurity = 0; nanind = 0;
i = 2;
ind = i+firstF-3;
mult = 1;
while (i>1 && i <= size(target.IDhist,2))   % Consider the track life
   
    ind = ind + 1;
    if ind > size(C_data{1},1)
       break;
    end
   
    % Occlusion Index
    Diff = str2double([C_data{1}{ind}(19) C_data{1}{ind}(20) C_data{1}{ind}(21)])...
    - str2double([C_data{1}{ind-1}(19) C_data{1}{ind-1}(20) C_data{1}{ind-1}(21)]);     
    Diff = Diff * mult;
    if Diff > 1                            % Check if it is occluded
        i = i + Diff - 1;
        ind = ind - 1;
        mult = 1/Diff;
        nanind = nanind + (Diff-1);
        if i > size(target.IDhist,2)
            nanind = nanind - (i-size(target.IDhist,2)-1);
        end
        continue;
    end
    mult = 1;
    % If it is not detected or dummy is ...
    ID = target.IDhist{i};
    if isempty(ID) == 1
        i = i + 1;
        continue;                   
    end
     
    % Check if the correct measurement is assigned
    if (target.x_aligned{i}(1) - (C_data{2}(ind)))^2 + (target.x_aligned{i}(2) - (C_data{3}(ind)))^2 < 400
        TrackPurity = TrackPurity + 1;   
    end
    i = i + 1;
end
metric.TrackPurity = TrackPurity / (size(target.IDhist,2)-nanind-1);
metric.CAR = TrackPurity / (nFrames-nanind-1);

%% Compute the Recall Rate - TP/TP+FN
TP = 0;  FN = 0;
i = 2;
ind = i+firstF-2;
while (i > 1 && i <= size(blobs,2))
   % Occlusion Index
   Diff = str2double([C_data{1}{ind}(19) C_data{1}{ind}(20) C_data{1}{ind}(21)])...
    - str2double([C_data{1}{ind-1}(19) C_data{1}{ind-1}(20) C_data{1}{ind-1}(21)]);     

   if Diff == 1                       % Check if it is occluded
        % Check if the target is in the ROI
	c = 0;
        if (roi.boundary{i}(1) < C_data{2}(ind) && roi.boundary{i}(2) > C_data{2}(ind)) ...
                && (roi.boundary{i}(3) < C_data{3}(ind) && roi.boundary{i}(4) > C_data{3}(ind))
            
            for j = 1:size(blobs{i},1) % Iterate through each detection
                                
                if ((blobs{i}(j,1) - (C_data{2}(ind)))^2+(blobs{i}(j,2) - (C_data{3}(ind)))^2) < 400
                    TP = TP + 1;
	  	    c = 1;
                end
                
            end
	    if (c == 0)
		FN = FN + 1;
	    end
        end
        i = i + 1;
    else i = i + Diff;
    end
    ind = ind + 1;
end
metric.Recall = TP / (TP+FN);

%% Compute the Precision Rate - TP/FP+TP
files = dir( fullfile(first,'*txt') );
files = {files.name}';
files = sort_nat(files);
FP = 0; TP = 0;
for depth = 2:size(blobs,2)
    for in = 1:size(blobs{depth},1)
        if isempty(blobs{depth}) == 1; % If there is no detected object
            break;
        end
        
        for findex = 1:size(files,1)
            %% Read data (coordinates of the TOI)
            fid = fopen([first,files{findex}],'r');
            C_data = textscan(fid, '%s %d %d');
            fclose(fid);
            toa = [];
            Cdata = cell2mat(C_data{1});
            
	    %% Initial Time of Appearance
            toa = str2num([Cdata(:,19) Cdata(:,20) Cdata(:,21)]); 
            
            if toa(end) < IF
                continue;
            end
            
            index = find(toa==IF+depth-1);
            if isempty(index) == 1;
                continue;
            end
            
            if (blobs{depth}(in,1) - (C_data{2}(index)))^2+(blobs{depth}(in,2) - (C_data{3}(index)))^2 < 400
               TP = TP + 1;
               temp = 1;
               break;
            else temp = 0;
            end
        end
        if temp == 0;
            FP = FP + 1;
        end
    end
end
metric.Precision = TP / (TP+FP);
