function [hist]=spectraremove(hist,ID,Type,time)
%% THIS FUNCTION KEEPS THE MATCHED SPECTRA, REMOVING OTHERS
if Type == 1
    for i = 1:size(hist.pred{1},2)
        if i ~= ID
            hist.pred{time}{i} = [];
        end
    end
else
    for i = 1:size(hist.detect{time},2)
        if i ~= ID
            hist.detect{time}{i} = [];
        end
    end
end
