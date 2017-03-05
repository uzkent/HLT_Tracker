function [car]=carmetric(fl,duration)
% -------------------------------------------------------------------------
% Explanation :
%       This Routine Measures the Current Assignment Ratios for a given MC 
%   runs. It is the ratio of the number of true measurements originating
%   from ground truth assigned to the track and duration of true
%   measurements
%   Cited Paper : Track Purity and Current Assignment Ratio for Target
%   Tracking and Identification Evaluation
% -------------------------------------------------------------------------
car = 0;
for i=1:size(fl,2)
    car = car + 100*(sum(fl{i}.tp)/duration);
end
car = car/size(fl,2);