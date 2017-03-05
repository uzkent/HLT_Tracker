function [model]=svmtraining(model)
%% ------------------------------------------------------------------------
% Explanation:
%       This function trains the linear SVM with the dataset built offline.
%       Training is performed to detect regions as Car and Non-car. In the
%       training set there are 40 positive and 28 negative samples.
%% -------------------------------------------------------------------
matfile='/Users/burakuzkent/Desktop/Training_Data/Training_Set_IntegralHoG.mat';
load(matfile);
model.linearSVM = svmtrain(train_label, train_data, '-t 0 -b 1 -q');
clear train_label train_data train_samples