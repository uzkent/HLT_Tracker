function [c]=SDAssignment(model,target,tID,hist,bh,time)
%% Spectral Feature Matching Aided S-D Assignment Algorithm
% =========================================================================
%   Explanation :   
%       This function performs multi-dimensional assignment for the track
%       of interest. It checks for N previos scans to perform association.
%       Track in the k-N th time step is considered and updated up to the
%       current time step. In each scan, only spectrally matched objects 
%       are considered.
%   Author : Burak Uzkent
%   Cited Paper : Ground Target Tracking with Variable Structure IMM
%   Estimator
% =========================================================================
% Get the track on the k-N+1 th time step
N=model.N;        % Number of past scans to consider
PD=model.PD;      % Detection Probability

% Possible associations in the k-S+2 to the kth time step
c=1;
for i=N-2:-1:0
    mindex=hist.MatchInd{tID,time-i};
    if isempty(mindex)==0;
        ind{c}=mindex;
        ind{c}=[0 ind{c}];            % Add dummy measurement for each step
    else ind{c}=0;
    end
    c=c+1;
end
% Generate a list of possible tuples(a) through the last S scans.
d = cell(1, numel(ind));
[d{:}] = ndgrid( ind{:} );
a = cell2mat( cellfun(@(v)v(:), d, 'UniformOutput',false) );
    
% Generate cost (c) matrix through the last S scans for the given tuples
phi_n=ones(1,size(a,1));
phi_o=ones(1,size(a,1));

% Evaluate the costs
vol=((4/3)*90^3*pi)^-1;                          % Surveillance Volume
for i=1:size(a,1)
    mu=target.x{tID,time-N+1};                   % Track at T(k-S+1)
    sig=target.c{tID,time-N+1};
    for n=1:size(a,2)
         if a(i,n)~=0                            % Non-Dummy Measurement
            v=bh{time-N+n+1}(a(i,n),:)';         % Measurement
            [mu,sig]=SD_time_up(model,mu,sig);   % Time Update
            S=model.H*sig*model.H'+model.R;      % Innovation Covariance
            S=S(1:2,1:2); iv=v(1:2)-mu(1:2);
            lhood=(2*pi)^-1*det(S)^-0.5*exp(-0.5*(iv)'*inv(S)*(iv));% Cost
            [mu,sig]=SD_meas_up(model,mu,sig,v); % Measurement Update
            phi_o(tID,i)=phi_o(tID,i)*vol;       % Dummy Track
            phi_n(tID,i)=phi_n(tID,i)*PD*lhood;
         else phi_n(tID,i)= phi_n(tID,i)*(1-PD); % Dummy Measurement
            [mu,sig]=SD_time_up(model,mu,sig);   % Time Update (Dummy)
            phi_o(tID,i)=phi_o(tID,i)*1;
         end
    end
end
% Compute the final cost
c=-log(phi_n./phi_o);