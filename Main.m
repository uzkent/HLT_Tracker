function [metric]=Main(id)
clearvars -except metric id 
close all
% ------------------------------------------------------------------------
% SOURCE FILE OF THE OBJECT TRACKING ALGORITHM USING AN ADAPTIVE SENSOR
% AUTHOR: Burak Uzkent
% DATE : 08/13/2014
% ROCHESTER INSTITUTE OF TECHNOLOGY
% FOR MORE INFORMATION GO TO READ_ME.TXT FILE
% -------------------------------------------------------------------------

%% LOAD DATA
Dt = dlmread('Input.txt');   % Input Data
PanHandle = matfile('/Users/burakuzkent/Desktop/Research/Tracking/Scenario/hsipan.mat');
I_F = Dt(id,2);                       % Initial frame where the TOI appears
I_Fin = Dt(id,3);                     % Final Frame for tracking
target.user_x = Dt(id,4);             % Initial X coordinate of TOI
target.user_y = Dt(id,5);             % Initial Y coordinate of TOI

% % Open a video
% Vid = VideoWriter(['Car' num2str(id) '.avi'],'Uncompressed AVI');
% Vid.FrameRate = 3;
% open(Vid);
% fig = figure(1);
% set(fig, 'Position', [0, 0.00, 1200, 1200]);

%% CREATE THE MODEL
model = [];
[model]=modeldefine(model);

%% DEFINE THE COVARIANCE MATRICES   
[model]=covarianceinit(model);

%% ASSIGN WEIGHTS TO THE COMPONENTS
[Weight]=assignweight(model);

%% INITIATE PARAMETERS - Spectral Threshold - Kinematic Gate Threshold...
time=0; counter=1; flag=0; number2=0; vmeas = []; cov_init=0;
target.Sp_Fthresh=[];    
target.Kn_Thresh =[ 100, 100];
target.lost=zeros(2); 
hist.detect=[]; 
roi = [];

%% THE DETECTION ROUTINE
Detection
