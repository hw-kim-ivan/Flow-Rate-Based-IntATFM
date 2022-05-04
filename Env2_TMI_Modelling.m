%{

File:       Env2_TMI_Modelling.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% clear all; clc;
% Env2_Result      = [];
% Env2_CTO_MINIT   = [];
% Env2_CTO_FRbT    = [];
% Env2_Delay_MINIT = 0;
% Env2_Delay_FRbT  = 0;
% ETO              = [3 11 14 20 22 25 28 32 41 53 54 56];
% Capacity         = sum([2 1 1]);
% Env2_MINIT       = 15;
% LOASep           = 6;

%% Define Function
function [Env2_Result] = Env2_TMI_Modelling( Env2_Result, Env2_CTO_MINIT, Env2_CTO_FRbT, Env2_Delay_MINIT, Env2_Delay_FRbT, ETO, Capacity, Env2_MINIT, LOASep)
%% Modelling Integrated DCB in Once
[Env2_CTO_MINIT, Env2_Delay_MINIT]  = ModellingTMI_MINIT( ETO, LOASep, Env2_MINIT, Capacity );% clc;
[Env2_CTO_FRbT, Env2_Delay_FRbT]    = ModellingTMI_FRbT( ETO, LOASep, Capacity );% clc;

%% Cat Results
Env2_Result                 = struct();
Env2_Result(1).CTO_MINIT    = Env2_CTO_MINIT;
Env2_Result(1).CTO_FRbT     = Env2_CTO_FRbT;
Env2_Result(1).Delay_MINIT  = Env2_Delay_MINIT;
Env2_Result(1).Delay_FRbT   = Env2_Delay_FRbT;
end % function