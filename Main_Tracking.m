function [metric]=Main_Tracking(id,model,coeffs,nGauss,NoiseIndex)
model.NL =  8 * 0.05 + 0.2;	      % Noise Parameter - Defines the How much noise is added onto the original DIRSIG Images
% model.alpha = (NoiseIndex + 4) * 0.1;
N_Groups = [3,6,10,15];		      % How many groups to form out of Spectral Channels
model.N_LMaps = 6;   		      % N_Groups(4)+1; Number of likelihood maps to represent the full spectrum
clearvars -except metric id model     % Clear the variables from the previous run
close all			      % Close the Window

%% LOAD DATA
Dt = dlmread('Input_2.txt');          % Input Data - Target Information - ID, First Frame, Last Frame, 
				      % Initial Position (X,Y) and Width Height
I_F = Dt(id,2);                       % Initial frame where the TOI appears
I_Fin = Dt(id,3);                     % Final Frame for tracking - Dt(id,3) -> represents 
				      % the final frame of the target of interest
target.user_x = Dt(id,4);             % Initial X coordinate of target given by the user
target.user_y = Dt(id,5);             % Initial Y coordinate of target given by the user

%% CREATE THE MODEL - for the Gaussian Mixture Filters
[model]=modeldefine(model);

%% DEFINE THE COVARIANCE MATRICES - for the Gaussian Kernels of the GMF
[model]=covarianceinit(model);

%% ASSIGN WEIGHTS TO THE COMPONENTS
[Weight]=assignweight(model);

%% INITIATE PARAMETERS - Spectral Threshold - Kinematic Gate Threshold...
time=0; counter=1; flag=0; number2=0; vmeas = []; cov_init=0; 
target.Sp_Fthresh=[];  %% Define the Spectral Threshold to Filter Blobs
target.Kn_Thresh = [70 70]; %% ROI Dimension - Width/2, Height/2
target.lost=zeros(2); hist.detect=[]; roi = []; counter = 0;
target.N_Pixs = ones(model.N_LMaps,1) ./ model.N_LMaps;
target.LF_Weights = ones(model.N_LMaps,1) ./model.N_LMaps; %% Initial Likelihood Fusion

%% THE DETECTION ROUTINE - Call the Detection Routine
Detection
