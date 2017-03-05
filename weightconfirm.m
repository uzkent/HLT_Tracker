function [Weight]=weightconfirm(Weight,time)
%% This function chechks if any weight is below some certain threshold
% Get the size of the weight parameter
n=size(Weight.Measurement{time},1);
for i=1:n
[minweight,minindex]=min(Weight.Measurement{time}(i,:));
[maxweight,maxindex]=max(Weight.Measurement{time}(i,:));
    %if time==17 || time==25%minweight<0.05
    if time==4 %minweight<0.05
       Weight.Measurement{time}(i,:)=Weight.Measurement{1}(1,:); 
    end
    %if maxweight>=0.9999;
    %   F1.weight{time}(i,maxindex)=0.95;
    %   F1.weight{time}(i,minindex)=F1.weight{time}(i,minindex)+0.05;
    %end
end
