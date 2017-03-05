function []=trackingParallel(N)
n = 0;
for j = (labindex-1)*(N/numlabs)+1:labindex*(N/numlabs)
    [metric] = Main_Detection(35);
end
labindex
filename=strcat('detection',int2str(labindex),'.mat');
save(filename);
