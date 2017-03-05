function [Weight]=FPKE_Update(Weight,M,N,model,time,j,promtrack)
%% THIS FUNCTION UPDATES THE WEIGHTS USING CKE METHOD
% % get the weights   
% Aeq = ones(1,model.n); beq =1; Ain = -eye(model.n); bin = zeros(model.n,1);
% %xx = sdpvar(model.n,1);
% xx_old = reshape(F1.weight{time-1}(j,:),model.n,1);
% %cons = set(Aeq*xx == beq) + set(Ain*xx < bin);
% %assign(xx, xx_old);
% optyalmip = sdpsettings('solver','quadprog','verbose',0,'usex0',1);
% %solvesdp(cons,1/2*xx'*M*xx + xx'*N*xx_old, optyalmip); 
% H = M;
% f = N*xx_old;
% [xx,fval,exitflag] = quadprog(H,-f,Ain,bin,Aeq,beq,zeros(size(xx_old)),ones(size(xx_old)),xx_old,optimset('display','iter','algorithm','active-set','LargeScale','off'));
% %[xx,fval,exitlag]=quadprog(H,-f,Ain,bin,Aeq,beq,zeros(size(xx_old)),ones(size(xx_old)),[],optimset('Display','off','algorithm','interior-point-convex','LargeScale','off','MaxIter',1000));
% F1.weight{time}(j,:)=double(xx);
% %exitflag
% %F3.w{k} = double(xx);
% %saveF3w = F3.w{k};

% get the weights   
cc = ones(model.n,1);
xx = sdpvar(model.n,1);
xx_old = reshape(Weight.Measurement{time-1}(promtrack(j,1),:),model.n,1);
optyalmip = sdpsettings('solver','quadprog','verbose',0,'usex0',1);
const = set(cc'*xx == 1) + set(xx >= 0);
solvesdp(const,1/2*xx'*M*xx - xx'*N*xx_old,optyalmip);    
Weight.Measurement{time}(promtrack(j,1),:)=double(xx);
%saveF3w = F3.w{k};
