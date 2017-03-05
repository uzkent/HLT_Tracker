function [metric]=Main_Detection(id)
clearvars -except metric id
close all

%% LOAD DATA
Dt = dlmread('Input_MoreSamples.txt');   % Input Data
I_F = Dt(id,2);                       % Initial frame where the TOI appears
I_Fin = Dt(id,3);                     % Final Frame for tracking
target.user_x = Dt(id,4);             % Initial X coordinate of TOI
target.user_y = Dt(id,5);             % Initial Y coordinate of TOI

first = '/Users/burakuzkent/Desktop/Research/Tracking/Ground_Truth/Scenario1_NoTrees/';
second = Dt(id,1);
fid = fopen([first,num2str(second),'_track.txt'],'r');

%% Read data (coordinates of the TOI)
C_data = textscan(fid, '%s %d %d');

%% Initial Time of Appearance
PanHandle = matfile('/Users/burakuzkent/Desktop/Research/Tracking/Scenario/hsipan.mat');
Cdata = cell2mat(C_data{1});
toa = str2num([Cdata(:,19) Cdata(:,20) Cdata(:,21)]); 
Indx = find(toa==Dt(id,2)+1);

for i = 1:size(Cdata,1)-1
    Diff(i) = str2num([Cdata(i+1,19) Cdata(i+1,20) Cdata(i+1,21)])-str2num([Cdata(i,19) Cdata(i,20) Cdata(i,21)]); 
end

%% CREATE THE MODEL
model = [];
[model]=modeldefine(model);

%% DEFINE THE COVARIANCE MATRICES   
[model]=covarianceinit(model);

%% ASSIGN WEIGHTS TO THE COMPONENTS
[Weight]=assignweight(model);

%% INITIATE PARAMETERS - Spectral Threshold - Kinematic Gate Threshold...
time=0; counter=1; flag=0; number2=2; vmeas = []; cov_init=0;
target.Sp_Fthresh=[];    
target.Kn_Thresh = [model.firstGate(1) model.firstGate(2)];
target.lost=zeros(2); 
hist.detect=[]; 
roi = [];

%% THE DETECTION ROUTINE
Detection