function [target,hist]=deletion(target,hist,time)
%% DELETE SOME ELEMENTS AFTER EACH STEP FOR MEMORY PURPOSE
if time > 2
    hist.detect{time-1}=[];
    hist.pred{time-1}=[];
    target.wholedetect{time}=[];
    target.detect{time-1}=[];
end