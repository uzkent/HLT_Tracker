function [target]=FA_SD(cf,ml,hist,target,tID,bh,tm)
%% Spectral Feature Aided S-D Assignment Algorithm
% =========================================================================
%   Explanation :   
%       This function performs multi-dimensional assignment for the track
%       of interest. It checks for N previos scans to perform association.
%       Track in the k-N th tm step is considered and updated up to the
%       current tm step. In each scan, only spectrally matched objects 
%       are considered.
%   Author : Burak Uzkent
%   Cited Paper : Ground Target Tracking with Variable Structure IMM
%   Estimator
% =========================================================================
%% Get the track on the k-N+1 th tm step
if tm > ml.N
    N=ml.N;         % Number of past scans to consider
    PD=ml.PD2;      % Detection Probability
else
    N=tm;           % If there is not enough history, use N = history
    PD=ml.PD1;      % Detection Probability
end

%% Possible associations in the k-S+2 to the kth time step
c=1;
for i=N-2:-1:0
    mindex=hist.MatchInd{tID,tm-i};
    if isempty(mindex)==0;
        ind{c}=mindex;
        ind{c}=[0 ind{c}];            % Add dummy measurement for each scan
    else ind{c}=0;
    end
    c=c+1;
end

% Generate a list of possible tuples(a) through the last S scans.
d = cell(1, numel(ind));
[d{:}] = ndgrid( ind{:} );
a = cell2mat( cellfun(@(v)v(:), d, 'UniformOutput',false) );
    
% Eliminate unlikely consecutive measurements
[a]=tuplerefine(a,bh,tm);

%% Evaluate the spectral scores
vol=((4/3)*200^3*pi)^-1;                       % Surveillance Volume
tuple_rs = size(a,1);                          % # of rows in tuple list
tuple_cs=size(a,2);                            % # of cols in tuple list
PM = zeros(1,tuple_cs);                        % Prob. of detection (Sp.) 
PL = zeros(1,tuple_cs);                        % Prob. of loss (Sp.) 
SumSd = zeros(1,tuple_cs);

%% Evaluate Overall Costs - Kinematic + Spectral Costs
% Generate cost (c) matrix through the last S scans for the given tuples
phi_n=ones(1,tuple_rs);
phi_o=ones(1,tuple_rs);
mu=cell(1,tuple_rs);
sig=cell(1,tuple_rs);
for n=1:tuple_cs
    dup=[];                      % Array for duplicate tuples
    for i=1:tuple_rs
         if n==1
            mu{1,i}=target.x{tID,tm-N+1};               % Track at T(k-S+1)
            sig{1,i}=target.c{tID,tm-N+1};
         end
         
         % Already Estimated? (Only Mu, Sig, and Cost required)
         if isempty(dup)==0
            ix=find(any(all(bsxfun(@eq,a(i,1:n),dup),2),3));
         else ix=[];
         end
         if isempty(ix)==0
            mu{1,i}=mu{1,ix}; 
            sig{1,i}=sig{1,ix};
            phi_n(1,i)=phi_n(1,ix);
            phi_o(1,i)=phi_o(1,ix);
            continue;
         else
            dup=[dup;a(i,1:n)];
         end
         
         if a(i,n)~=0                           % Non-Dummy Measurement
            v=bh{tm-N+n+1}(a(i,n),1:4)';          % Measurement
            mu{1,i} = ml.FCV * mu{1,i};
            sig{1,i} = ml.FCV * sig{1,i} * ml.FCV'+ ml.Rsd;
            S = ml.H*sig{1,i}*ml.H';%+ml.Rsd;
            iv = mu{1,i}(1:2) - v(1:2);
            
            eucdis=sqrt(iv * iv');                  % Euclidean Distance
            if eucdis > 60                          % Distance Elimination
                phi_n(1,i)=10^-900; phi_o(1,i)=1;   % Infinite Penalty
                continue;
            end
            
            Sm=S(1:2,1:2);
            lhood=(2*pi)^-1*det(Sm)^-0.5*exp(-0.5*(iv)'*(Sm\iv));% Cost
            s = size(target.Sp_Fthresh,2);
            Msd=target.Sp_Fthresh{s} - cf{tm-N+n+1}(a(i,n)); % Norm. Fs
            PS=PM(n)*(Msd/SumSd(n));            % Spectral likelihood
            phi_o(1,i)=phi_o(1,i)*vol;          % Dummy Track
            phi_n(1,i)=phi_n(1,i)*PD*lhood;     % Nondummy Track
            
            S = ml.H*sig{1,i}*ml.H'+ml.R;
            gain = (sig{1,i} * ml.H')/S;                % Gain
            sig{1,i} = sig{1,i} - gain*ml.H*sig{1,i};   % Covariance 
            mu{1,i} = mu{1,i} + gain*(v-mu{1,i}(1:4));  % Mean
         else phi_n(1,i)= phi_n(1,i)*(1-PD);      % Dummy Measurement
            mu{1,i} = ml.FCV * mu{1,i};
            sig{1,i} = ml.FCV * sig{1,i} * ml.FCV'+ ml.Q;
         end
    end
end

% Compute the final cost - Direct Cost Minimization
target.C=-log(phi_n./phi_o);
target.tuple = a;
[~,assig] = min(target.C);
target.as{tID}=a(assig,end);
