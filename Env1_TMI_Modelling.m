%{

File:       Env1_TMI_Modelling.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% clear all; clc;
% Env1_Result      = [];
% Env1_CTO_MINIT   = [];
% Env1_CTO_FRbT    = [];
% Env1_Delay_MINIT = 0;
% Env1_Delay_FRbT  = 0;
% NumOfPlayer      = 3;
% ETO              = [3 11 14 20 22 25 28 32 41 53 54 56];
% Player_idx       = [{[2 5 7]} {[1 3 4 9 10 12]} {[6 8 11]}];
% Capacity         = [2 1 1];
% Env1_MINIT       = [30 60 60];
% LOASep           = 6;

%% Define Function
function [Env1_Result] = Env1_TMI_Modelling( Env1_Result, Env1_CTO_MINIT, Env1_CTO_FRbT, Env1_Delay_MINIT, Env1_Delay_FRbT, NumOfPlayer, ETO, Player_idx, Capacity, Env1_MINIT, LOASep)
PlayerA_idx = Player_idx{1};
PlayerB_idx = Player_idx{2};
PlayerC_idx = Player_idx{3};
%% Modelling Independent DCB for each player
for player = 1 : NumOfPlayer
    switch player;
        case 1
            [CTO_MINIT, Delay_MINIT]    = ModellingTMI_MINIT( ETO(PlayerA_idx), LOASep, Env1_MINIT(player), Capacity(player) );% clc;
            [CTO_FRbT, Delay_FRbT]      = ModellingTMI_FRbT( ETO(PlayerA_idx), LOASep, Capacity(player) );% clc;
            Env1_Delay_MINIT            = Env1_Delay_MINIT + Delay_MINIT;
            Env1_Delay_FRbT             = Env1_Delay_FRbT + Delay_FRbT;
        case 2
            [CTO_MINIT, Delay_MINIT]    = ModellingTMI_MINIT( ETO(PlayerB_idx), LOASep, Env1_MINIT(player), Capacity(player) );% clc;
            [CTO_FRbT, Delay_FRbT]      = ModellingTMI_FRbT( ETO(PlayerB_idx), LOASep, Capacity(player) );% clc;
            Env1_Delay_MINIT            = Env1_Delay_MINIT + Delay_MINIT;
            Env1_Delay_FRbT             = Env1_Delay_FRbT + Delay_FRbT;
        case 3
            [CTO_MINIT, Delay_MINIT]    = ModellingTMI_MINIT( ETO(PlayerC_idx), LOASep, Env1_MINIT(player), Capacity(player) );% clc;
            [CTO_FRbT, Delay_FRbT]      = ModellingTMI_FRbT( ETO(PlayerC_idx), LOASep, Capacity(player) );% clc;
            Env1_Delay_MINIT            = Env1_Delay_MINIT + Delay_MINIT;
            Env1_Delay_FRbT             = Env1_Delay_FRbT + Delay_FRbT;
    end % switch player;

    Env1_CTO_MINIT   = [Env1_CTO_MINIT, CTO_MINIT];
    Env1_CTO_FRbT    = [Env1_CTO_FRbT, CTO_FRbT];
end % for player
%% Cat Results
Env1_Result                 = struct();
Env1_Result(1).CTO_MINIT    = Env1_CTO_MINIT;
Env1_Result(1).CTO_FRbT     = Env1_CTO_FRbT;
Env1_Result(1).Delay_MINIT  = Env1_Delay_MINIT;
Env1_Result(1).Delay_FRbT   = Env1_Delay_FRbT;
end % function [DCB_Scenario]