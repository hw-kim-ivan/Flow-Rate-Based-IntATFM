%{

File:       Submit_FPL.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%% Function Test
% clear all; clc;
% ETO_Set           = [];
% Demand_for_Player = [3 6 3];
% NumOfPlayer       = 3;

%% Define Function
function [ETO, Player_idx, PlayerA_idx, PlayerB_idx, PlayerC_idx] = Submit_FPL( ETO_Set, Demand_for_Player, NumOfPlayer )
%% Cat ETO of all players
while true
    ETO_Set = arrayfun(@(x) [ETO_Set, GenerateETO_Randperm( Demand_for_Player(x) )], 1:NumOfPlayer, 'UniformOutput', false);
    ETO     = sort( cell2mat(ETO_Set) );

    if numel( ETO ) == numel( unique(ETO) ); break;
    else; ETO_Set = []; % disp '--- ETO Collapsed ---'; 
    end;
    
end % while
%% Get flight idx of each player
PlayerA_idx = []; PlayerB_idx = []; PlayerC_idx = [];

PlayerA_ETO = ETO_Set{1};
PlayerB_ETO = ETO_Set{2};
PlayerC_ETO = ETO_Set{3};

PlayerA_idx = arrayfun( @(x) [PlayerA_idx, find( ETO==PlayerA_ETO(x) )], 1:numel(PlayerA_ETO) );
PlayerB_idx = arrayfun( @(x) [PlayerB_idx, find( ETO==PlayerB_ETO(x) )], 1:numel(PlayerB_ETO) );
PlayerC_idx = arrayfun( @(x) [PlayerC_idx, find( ETO==PlayerC_ETO(x) )], 1:numel(PlayerC_ETO) );

Player_idx  = [ {PlayerA_idx}, {PlayerB_idx}, {PlayerC_idx} ];
end % function