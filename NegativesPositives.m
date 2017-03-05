muTP = 0;
muCAR = 0;
muDTR = 0;
muFAR = 0;
muCAM = 0;
first = '/Users/burakuzkent/Desktop/New_Journal_Paper/Results/Tracking/Without_HoGSVM';
files = dir( fullfile(first,'*mat') );
files = {files.name}';
files = sort_nat(files);
c = 1;
for j = 1:size(files,1)
    load(['/Users/burakuzkent/Desktop/New_Journal_Paper/Results/Tracking/Without_HoGSVM/',files{j}]);
    for i=1:100
        muTP = muTP + metric{i}.TrackPurity;
        muCAR = muCAR + metric{i}.CAR;
        muDTR = muDTR + metric{i}.DetectionRate;
        muFAR = muFAR + metric{i}.FalseAlarmRate;
        muCAM = muCAM + metric{i}.CAM;
    end
    DTR(c) = mean(muDTR);
    FAR(c) = mean(muFAR);
    TP(c) = mean(muTP);
    CAR(c) = mean(muCAR);
    CAM(c) = mean(muCAM);
    c = c + 1;
    muTP = 0;
    muCAR = 0;
    muDTR = 0;
    muFAR = 0;
    muCAM = 0;
end
% -------------- POSITIVES ------------------------------------------------
A1 = [];
for i = 0:9
    A1 = [A1 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end

A2 = [];
for i = 10:19
    A2 = [A2 imresize(sum(Training_Data{i*20+1},3),[40 40])];
end

A3 = [];
for i = 20:29
    A3 = [A3 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end

A4 = [];
for i = 35:44
    A4 = [A4 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end
A = [A1;A2;A3;A4];
% -------------- NEGATIVES ------------------------------------------------
B1 = [];
for i = 100:109
    B1 = [B1 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end

B2 = [];
for i = 110:119
    B2 = [B2 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end

B3 = [];
for i = 120:129
    B3 = [B3 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end

B4 = [];
for i = 130:139
    B4 = [B4 imresize(sum(Training_Data{i*20+1},3),[40 40])];    
end
B = [B1;B2;B3;B4];