function [Sfn]=NoiseAdd(data,ml)
%% THIS FUNCTION ADDS NOISE TO THE INPUT DATA CONSIDERING RITMOS
% =========================================================================
% Explanation:
%   Irradiance values given by DIRSIG is converted to voltage. This
%   radiometric process accounts for the filter effects, dispersive
%   elements, detector elements, shot noise, A/D converters with readout
%   circuitry, integration time.
% Cited Paper : Feature Aided Tracking with Hyperspectral Imagery
% =========================================================================
[rows,cols,bands] = size(data);
sigma = 0.6;    % Transmittance of the optical platform
f = 200;        % Focal length of the lens in mm
d = 200;        % Aperture diameter in mm 
Ax = 17*10^-3;  % Detector array y dimension in cm 
Ay = 17*10^-3;  % Detector array x dimension in cm
A = Ax * Ay;    % Detector Area
tint = 10^-3;   % Integration time of the sensor in s
V_e = 0.8;      % Charge to voltage conversion (Volts per electron)
QE = 0.95;      % Quantum efficiency of the sensor (electrons per photon)
hc = 3.16152649*10^-26; % Planck's Constant
b = 5;          % Number of bits used in the processed data
L = data;       % Sensor Reaching Radiance
G = (1 + 4 * (f/d)^2)/(sigma*pi);  % Optical Throughput Equation
factor=tint * A * V_e * QE * (700*10^-9)^2/(hc);
E = L/G;        % Camera Equation
S = E*factor;
Vsat = 6*10^4;  % Maximum signal level
V_e = data * V_e;

%% ADD READ, SHOT NOISE AND ESTIMATE FINAL VOLTAGE
Nro = normrnd(0,30,[rows cols bands]).*V_e;
Nphi = normrnd(0,sqrt(S),[rows cols bands]);
Sfn = ((2^b.*(max(min(S+Nphi+Nro,Vsat),0))./(Vsat))+0.5).*2^-b; 
