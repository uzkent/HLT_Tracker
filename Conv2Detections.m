clear;
% first = '/Users/burakuzkent/Desktop/Research/Tracking/Ground_Truth/Scenario1_NoTrees/';
first = '/Users/burakuzkent/Desktop/Track_Extraction/';
files = dir( fullfile(first,'*txt') );
files = {files.name}';
files = sort_nat(files);
% Open a Input.txt file
c = 1;
for i = 1:size(files,1)
    fid = fopen([first files{i}]);
    Text = textscan(fid,'%s %f %f'); 
    Temp = cell2mat(Text{1}(1:end));
    Temp = str2num(Temp(:,18:21));
    Diff = Temp(2:end) - Temp(1:end-1);
    if Temp(end)<23
        continue;
    end
    if Temp(1)<23 
        z = find(Temp>=23);
        Text{1}(1:z(1)-1)=[];
        Text{2}(1:z(1)-1)=[];
        Text{3}(1:z(1)-1)=[];
    end
    if (str2double(Text{1}{end}(18:21))-str2double(Text{1}{1}(18:21))) < 30
        continue;
    end
    if (str2double(Text{1}{2}(18:21)) - str2double(Text{1}{1}(18:21))) > 1
        continue;
    end
    if round(Text{2}(1)) > 1480 || round(Text{3}(1)) > 1480
        continue;
    end
    if round(Text{2}(1)) < 20 || round(Text{3}(1)) < 20
        continue;
    end
    % Read the first Line
    if (sum((Text{2}(1:end)>20)-1)>-3 && sum((Text{2}(1:end)<1480)-1)>-30)...
        && (sum((Text{3}(1:end)>20)-1)>-3 && sum((Text{3}(1:end)<1480)-1)>-3)
        if (max(Diff)<50) % Maximum Allowable Disapperance
            Info(c,1) = str2double(files{i}(1:4));
            Info(c,2) = str2double(Text{1}{1}(18:21))-1;
            Info(c,3) = str2double(Text{1}{end}(18:21));
            Info(c,4) = round(Text{2}(1));
            Info(c,5) = round(Text{3}(1));
            c = c+1;
        end
    end
    fclose(fid);
end
dlmwrite('../../Input_MoreSamples_WTrees.txt',Info);
