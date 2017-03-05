function [xx]=FPKE_Update(M,N,model)
%% THIS FUNCTION UPDATES THE WEIGHTS USING FPKE METHOD
MVal{k} = M;
NVal{k} = N;
% get the weights   
Aeq = ones(1,prior.n); beq =1; Ain = -eye(prior.n); bin = zeros(prior.n,1);
xx = sdpvar(prior.n,1);
xx_old = reshape(F3.w{k-1},prior.n,1);
cons = set(Aeq*xx == beq) + set(Ain*xx < bin);
assign(xx, xx_old);
optyalmip = sdpsettings('solver','quadprog','verbose',0,'usex0',1);
%solvesdp(cons,1/2*xx'*M*xx + xx'*N*xx_old, optyalmip); 
H = M;
f = N*xx_old;
[xx,fval,exitflag] = quadprog(H,f,Ain,bin,Aeq,beq,zeros(size(xx_old)),ones(size(xx_old)),xx_old,optimset('display','iter','algorithm','active-set','LargeScale','off'));
exitflag
F3.w{k} = double(xx);
saveF3w = F3.w{k};