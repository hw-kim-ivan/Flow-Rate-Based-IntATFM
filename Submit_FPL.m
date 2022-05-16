%{

File:       Submit_FPL.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%% Define Function
function [ETO, PlayerA_idx, PlayerB_idx] = Submit_FPL( DemandForPlayer, NumOfPlayer )
%% Cat ETO of all players
ETO_Set = [];
while true
    ETO_Set = arrayfun(@(x) [ETO_Set, Generate_ETO_Randperm( DemandForPlayer(x) )], 1:NumOfPlayer, 'UniformOutput', false);
    ETO     = sort( cell2mat(ETO_Set) );

    if numel( ETO ) == numel( unique(ETO) ); break;
    else; ETO_Set = []; % disp '--- ETO Collapsed ---'; 
    end; % if numel( ETO )

end % while
%% Get flight idx of each player
PlayerA_ETO = ETO_Set{1};
PlayerB_ETO = ETO_Set{2};

PlayerA_idx = [];
PlayerB_idx = [];

PlayerA_idx = arrayfun( @(x) [PlayerA_idx, find( ETO==PlayerA_ETO(x) )], 1:numel(PlayerA_ETO) );
PlayerB_idx = arrayfun( @(x) [PlayerB_idx, find( ETO==PlayerB_ETO(x) )], 1:numel(PlayerB_ETO) );
end % function