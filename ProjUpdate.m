function [Weights]=ProjUpdate(model,A,b)
%% THIS FUNCTION PERFORMS QUADRATIC PROGRAMMING TO GET THE WEIGHTS
% get the weights   
cc = ones(model.n,1);
xx = sdpvar(model.n,1);
optyalmip = sdpsettings('solver','quadprog','verbose',0,'usex0',1);
const = [set(cc'*xx==1) set(xx >= 0.001)];
Objective=1/2*xx'*(A)'*A*xx+0.05*xx'*xx;
solvesdp(const,Objective,optyalmip);    
Weights=double(xx);