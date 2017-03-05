%% This function measures the performance of the detection and tracking module
function [wTp,wTgp,wPr,wRc] = EvaluateResults(metric)
metric2 = reshape(metric,[1,1,43]);
DR = 0; FAR = 0; TP = 0; TgP = 0; CaM = 0;
Pr = 0; Rc = 0; pr = []; rc = [];
dr = []; far = []; tp = []; tgp = []; cam = [];
Dt = dlmread('Input_2.txt');   % Input Data
snF = 0;
for bd = 1:size(metric2,2)
    snF = 0;
    for sd = 1:size(metric2,3)          % Go through each target
        for trs = 1:size(metric2,1)     % Go through each run

           TP = TP + metric2{trs,bd,sd}.TrackPurity;
           TgP = TgP + metric2{trs,bd,sd}.CAR;
	   Pr = Pr + metric2{trs,bd,sd}.Precision;
	   Rc = Rc + metric2{trs,bd,sd}.Recall;           

        end
        nF(bd,sd) = Dt(sd,3) - Dt(sd,2); % Number of Frames Involved
        snF = snF + nF(bd,sd);           % Total number of Frames   
        
	tp(bd,sd) = nF(bd,sd) * (TP / trs);
        tgp(bd,sd) = nF(bd,sd) * (TgP / trs);
        pr(bd,sd) = nF(bd,sd) * (Pr / trs);
        rc(bd,sd) = nF(bd,sd) * (Rc / trs);
        
	Pr = 0; Rc = 0; DR = 0; FAR = 0; TP = 0; TgP = 0; CaM = 0;

    end
end

%% Unweighted Results
uwTp = nanmean(tp ./ nF,2);
uwTgp = nanmean(tgp ./ nF,2);
uwPr = nanmean(pr ./ nF,2);
uwRc = nanmean(rc ./ nF,2);

%% Weighted Results
wTp = nansum(tp / snF,2);
wTgp = nansum(tgp / snF,2);
wPr = nansum(pr / snF,2);
wRc = nansum(rc / snF,2);
