function [target,hist]=spectraplacement(target,hist,nloc,time)
%% THIS FUNCTION PICKS THE SPECTRAS WITHIN DETECTED BLOBS and PLACES THEM 
% IN THE SAME BLOB
comp_size = size(target.mu_pred{time},2);  % Number of components
for i=1:comp_size
    mean = target.mu_pred{time}{i};
    for j=1:size(nloc,1)
       % Check if the spectra is collected in a detection blob
       if mean(1)>nloc(j,1)-5 && mean(1)<nloc(j,1)+5
          if mean(2)>nloc(j,2)-5 && mean(2)<nloc(j,2)+5
             % Place the spectras in the same basket 
             hist.detect{time}{j}=[hist.detect{time}{j} hist.pred{time}{i}]; 
          end
       end
    end
end