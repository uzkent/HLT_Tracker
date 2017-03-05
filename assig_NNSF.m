function [target]=assig_NNSF(model,target,assig,tID)
if sum(model.DA == 'NNSF')==4
    if target.C(tID,assig(tID))==1000 % This part is only for NNSF
        target.as{tID}=[];
    else target.as{tID}=assig(tID);
    end
end