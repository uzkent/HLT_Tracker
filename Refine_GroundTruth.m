first = '/Users/burakuzkent/Desktop/Research/Tracking/Ground_Truth/Scenario_Fixed/';
files = dir( fullfile(first,'*txt') );
files = {files.name}';
files = sort_nat(files);
A = cell2mat(files);
ind = str2num(A(:,1:4));
files = dir( fullfile(first,'*img') );
files = {files.name}';
files = sort_nat(files);
for i = 110:110
    full = [first files{i}];
    [Image,info] = enviread(full);
    for j = 1:size(ind,1)
        [x] = find(Image==ind(j));
        if size(x,1) < 10
            Image(x) = -1;
        end
    end
    enviwrite(Image,info,full,[full '.hdr']);
end