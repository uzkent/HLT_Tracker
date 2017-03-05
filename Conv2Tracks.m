clear;
ImageSize = [1500 1500];
InFrame = 10;
first = '/Users/burakuzkent/Downloads/Trackers_Comparison/Ground_Truth/';
% first = '/Users/burakuzkent/Desktop/Trial/';
files = dir( fullfile(first,'*txt') );
files = {files.name}';
files = sort_nat(files);
% Open a Input.txt file
c = 1;
for i = 1:size(files,1)
    fid = fopen([first files{i}]);
    Text = textscan(fid,'%s %f %f');  % Scan the text file
    fclose(fid);
    Ind = [];
    
    for j = 1:20
        Text{1}(Ind) = [];
        Text{2}(Ind) = [];
        Text{3}(Ind) = [];
        Temp = cell2mat(Text{1}(1:end));  % Convert to matrix
        Temp = str2num(Temp(:,18:21));    % Convert from string to numericals
        Diff = Temp(2:end) - Temp(1:end-1); % Find the appearance frames
        % Check the length of the target
        if Temp(end) < InFrame || size(Temp,1) < 20
            break;
        end
        % Find the tracks after 23th frame
        if Temp(1) < InFrame 
            z = find( Temp >= InFrame);
            Text{1}(1:z(1)-1)=[];
            Text{2}(1:z(1)-1)=[];
            Text{3}(1:z(1)-1)=[];
        end
        % Check the track length
        if (str2double(Text{1}{end}(18:21))-str2double(Text{1}{1}(18:21))) < 30 
            break;
        end
        % Check if it is occluded right after initiaiton
        if (str2double(Text{1}{2}(18:21)) - str2double(Text{1}{1}(18:21))) > 1
            Ind = 1;
            continue;
        end
        % Check how many times it is occluded in first five frames
        if (str2double(Text{1}{5}(18:21)) - str2double(Text{1}{1}(18:21))) > 6
            Ind = 1;
            continue;
        end
        % Check how many times it is occluded in first five frames
        if (str2double(Text{1}{10}(18:21)) - str2double(Text{1}{1}(18:21))) > 13
            Ind = 1;
            continue;
        end
        % Check if it gets ouf FOV in the first frame
        if round(Text{2}(1)) > ImageSize(1) - 20 || round(Text{3}(1)) > ImageSize(2) - 20
            Ind = 1;
            continue;
        end
        % Check if it gets ouf FOV in the first frame
        if round(Text{2}(1)) < 20 || round(Text{3}(1)) < 20
            Ind = 1;
            continue;
        end
        % Read the first Line
        if (sum((Text{2}(1:end)>20)-1)>-3 && sum((Text{2}(1:end)<ImageSize(1) - 20)-1)>-30)...
            && (sum((Text{3}(1:end)>20)-1)>-3 && sum((Text{3}(1:end)<ImageSize(1) - 20)-1)>-3)
            Info(c,1) = str2double(files{i}(1:4));
            Info(c,2) = str2double(Text{1}{1}(18:21))-1+1;
            Info(c,3) = str2double(Text{1}{end}(18:21));
            Info(c,4) = round(Text{2}(1));
            Info(c,5) = round(Text{3}(1));
            c = c+1;
            break;
        end
    end
    
end
dlmwrite('Input_Comparison.txt',Info);
