function [metric]=Main_Tracking_WoutHoG(id,model,coeffs,nGauss)
model.coeffs = coeffs;
model.n = nGauss * 4 + 1;
clearvars -except metric id model
close all

%% LOAD DATA
Dt = dlmread('Input_MoreSamples_WTrees.txt');   % Input Data
I_F = Dt(id,2);                       % Initial frame where the TOI appears
I_Fin = Dt(id,3);                     % Final Frame for tracking
target.user_x = Dt(id,4);             % Initial X coordinate of TOI
target.user_y = Dt(id,5);             % Initial Y coordinate of TOI

%% CREATE THE MODEL
[model]=modeldefine(model);

%% DEFINE THE COVARIANCE MATRICES   
[model]=covarianceinit(model);

%% ASSIGN WEIGHTS TO THE COMPONENTS
[Weight]=assignweight(model);

%% INITIATE PARAMETERS - Spectral Threshold - Kinematic Gate Threshold...
time=0; counter=1; flag=0; number2=0; vmeas = []; cov_init=0;
target.Sp_Fthresh=[];    target.Kn_Thresh = [50 50];
target.lost=zeros(2); hist.detect=[]; roi = []; counter = 0;

%% THE DETECTION ROUTINE
Detection_WoutHoG
