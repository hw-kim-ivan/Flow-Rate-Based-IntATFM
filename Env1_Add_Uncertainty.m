%{

File:       Env1_Add_Uncertainty.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% clear all; clc;
% CTO_MINIT       = [19 49 79 2 62 122 182 242 302 11 71 131];
% CTO_FRbT        = [19 27 60 2 60 120 180 240 300 11 60 120];
% uncertainty_A   = [1.0779 8.4266 -0.2396];
% uncertainty_B   = [2.3984 -1.0421 0.5527 0.8135 2.8027 3.8843];
% uncertainty_C   = [5.2019 2.5077 7.2620];

%% Define Function
function [Env1_ATO_MINIT, Env1_ATO_FRbT] = Env1_Add_Uncertainty( CTO_MINIT, CTO_FRbT, uncertainty_A, uncertainty_B, uncertainty_C );
Env1_uncertainty = [uncertainty_A, uncertainty_B, uncertainty_C];
Env1_ATO_MINIT   = sort( CTO_MINIT + Env1_uncertainty );
Env1_ATO_FRbT    = sort( CTO_FRbT + Env1_uncertainty );
end % function