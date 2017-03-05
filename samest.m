function [sam_score,index]=samest(h1,h2)
%% This function calculates the correlation between two spectral vector by 
% using SAM method
% Author : Burak Uzkent
% -------------------------------------------------------------------------
sam_score = acosd((h1 / norm(h1))' * (h2 / norm(h2)));
