function [metric]=Main_Detection_WoutHoG(model)
clearvars -except metric id model
close all

%% LOAD DATA
Dt = dlmread('Input.txt','|', 1,0);   % Input Data
I_F = Dt(id,1);                       % Initial frame where the TOI appears
I_Fin = Dt(id,2);                     % Final Frame for tracking
target.user_x = Dt(id,3);             % Initial X coordinate of TOI
target.user_y = Dt(id,4);             % Initial Y coordinate of TOI

first = '/home/bxu2522/Scenario1/';
second = Dt(id,5);
fid = fopen([first,num2str(second),'_track.txt'],'r');

%% Read data (coordinates of the TOI)
C_data = textscan(fid, '%s %d %d');

%% Initial Time of Appearance
Cdata = cell2mat(C_data{1});
toa = str2num([Cdata(:,19) Cdata(:,20) Cdata(:,21)]); 
Indx = find(toa==Dt(id,1)+1);

for i = 1:size(Cdata,1)-1
    Diff(i) = str2num([Cdata(i+1,19) Cdata(i+1,20) Cdata(i+1,21)])-str2num([Cdata(i,19) Cdata(i,20) Cdata(i,21)]); 
end

%% CREATE THE MODEL
[model]=modeldefine(model);

%% DEFINE THE COVARIANCE MATRICES   
[model]=covarianceinit(model);

%% ASSIGN WEIGHTS TO THE COMPONENTS
[Weight]=assignweight(model);

%% INITIATE PARAMETERS - Spectral Threshold - Kinematic Gate Threshold...
time=0; counter=1; flag=0; number2=2; vmeas = []; cov_init=0;
target.Sp_Fthresh=[];    target.Kn_Thresh = [50 50];
target.lost=zeros(2); hist.detect=[]; roi = []; counter = 0;

%% THE DETECTION ROUTINE
Detection_Tracking_WoutHoG
