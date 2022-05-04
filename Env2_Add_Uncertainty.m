%{

File:       Env2_Add_Uncertainty.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% clear all; clc;
% CTO_MINIT       = [19 49 79 2 62 122 182 242 302 11 71 131];
% CTO_FRbT        = [19 27 60 2 60 120 180 240 300 11 60 120];
% Player_idx      = [{[8 9 10]}, {[2 3 4 7 11 12]}, {[1 5 6]}];
% uncertainty_A   = [1.0779 8.4266 -0.2396];
% uncertainty_B   = [2.3984 -1.0421 0.5527 0.8135 2.8027 3.8843];
% uncertainty_C   = [5.2019 2.5077 7.2620];

%% Define Function
function [Env2_ATO_MINIT, Env2_ATO_FRbT] = Env2_Add_Uncertainty( CTO_MINIT, CTO_FRbT, Player_idx, uncertainty_A, uncertainty_B, uncertainty_C );
PlayerA_idx     = Player_idx{1};
PlayerB_idx     = Player_idx{2};
PlayerC_idx     = Player_idx{3};
Total_Demand    = numel( horzcat( Player_idx{:} ) );

Env2_uncertainty                = zeros( 1, Total_Demand );
Env2_uncertainty( PlayerA_idx ) = uncertainty_A;
Env2_uncertainty( PlayerB_idx ) = uncertainty_B;
Env2_uncertainty( PlayerC_idx ) = uncertainty_C;

Env2_ATO_MINIT   = CTO_MINIT + Env2_uncertainty;
Env2_ATO_FRbT    = CTO_FRbT + Env2_uncertainty;
end % function