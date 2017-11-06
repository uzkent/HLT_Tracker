function [model]=modeldefine(model)
%% ========================================================================
% THIS FUNCTION CREATES THE MODELS TO BE USED FOR THE FILTERING
%% ========================================================================
fid = fopen('ModelParameters.txt');
c = 1;
lineSkip = 0;
firstLine = 5;
while ~feof(fid)
    par(c) = textscan(fid,'%s',1,'delimiter','\n','headerlines',firstLine+lineSkip);
    lineSkip = 3;
    firstLine = 0;
    c = c + 1;
end
fclose(fid);
    
model.fn = 7;                  % State space dimensionality
model.fx = 'fxLorenz';
model.hx = 'hxSquaredRoot';
model.DA = 'SD';               % Data Association Filter (NNSF & PDAF & MHT)
model.sample='sample2';
model.Feature_Extraction = 'WeightedHistogram'; % Feature extraction method
model.Q = eye(model.fn)/2;     % Covariance Noise Matrix
model.H = eye(4,model.fn);     % H matrix
model.R = randi([1 1])*eye(4)*2.25; % Innovation Noise Covariance Matrix
model.R(3,3)=10;
model.R(4,4)=10;
model.Rsd=randi([15 25])*eye(7); % MDA based DA innovation noise (Adapted for MC runs)
model.PD1=0.01*randi([100 100]); % Probability of Detection (Adapted for MC runs)
model.PD2=0.01*randi([95 95]);   % Probability of Detection (Adapted for MC runs)
model.PG=0.01*randi([95 95]);    % Probability of Detecting target within a physical gate 
model.N = 5;                     % Number of Scans to be considered by MDA
model.Tndvi = 25;
model.alpha = str2double(par{2});
model.dims{1}(1) = 10;
model.dims{1}(2) = 4;
model.dims{2}(1) = 4;
model.dims{2}(2) = 10;
model.dims{3}(1) = 7;
model.dims{3}(2) = 7;
model.level1 = str2double(par{5});
model.level2 = str2double(par{6});
model.level3 = 5;

model.D = str2double(par{7});
model.n = 33; %str2double(par{8});
model.dt = str2double(par{9});
model.im_res(1) = str2double(par{10});
model.im_res(2) = str2double(par{11});
model.firstGate(1) = str2double(par{12});
model.firstGate(2) = str2double(par{13});
model.followingGate(1) = str2double(par{14});
model.followingGate(2) = str2double(par{15});

%% Load the Shadow and Road Spectral Data for Classification using SVMs
load Homography_07.mat
model.Ho = H;               % Transfer homography matrix to a global variable

%% ========================================================================
% DEFINE THE CV MODEL 
%% ========================================================================
syms Vx Vy width h x y w dt      % Define the state space parameters
v=[x, y, width, h, Vx, Vy, w];   % Jacobian matrix parameters
% Transition matrix - For the step t+1 and t+2
model.FCV=[     1     0     0     0     model.dt     0     0;
     0     1     0     0     0     model.dt     0;
     0     0     1     0     0     0     0;
     0     0     0     1     0     0     0;
     0     0     0     0     1     0     0;
     0     0     0     0     0     1     0;
     0     0     0     0     0     0     1];
model.FFCV=[     1     0     0     0     2*model.dt     0     0;
     0     1     0     0     0     2*model.dt     0;
     0     0     1     0     0     0     0;
     0     0     0     1     0     0     0;
     0     0     0     0     1     0     0;
     0     0     0     0     0     1     0;
     0     0     0     0     0     0     1];
 
%% ========================================================================
%  DEFINE THE STOP MODEL
%% ========================================================================
model.FSTOP=[ 1, 0, 0, 0, model.dt/2,    0, 0;
0, 1, 0, 0,    0, model.dt/2, 0;
0, 0, 1, 0,    0,    0, 0;
0, 0, 0, 1,    0,    0, 0;
0, 0, 0, 0,    0,    0, 0;
0, 0, 0, 0,    0,    0, 0;
0, 0, 0, 0,    0,    0, 0];
%% ========================================================================

%% ========================================================================
%  DEFINE THE NEARLY CONSTANT TURN MODEL 
%% ========================================================================
model.fCT=[x+(Vx*sin(w*dt)/w)-(Vy*(1-cos(w*dt))/w); 
y+(Vx*(1-cos(w*dt))/w)+(Vy*sin(w*dt)/w); width; h; 
Vx*cos(w*dt)-Vy*sin(w*dt); Vx*sin(w*dt)+Vy*cos(w*dt);w];

model.FCT=jacobian(model.fCT, v);   % Estimate the Jacobian for turn models

%% ========================================================================
% ========================================================================
