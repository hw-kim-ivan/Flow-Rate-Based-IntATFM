%{

File:       Env1_TMI_Modelling.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%% Define Function
function [Env1_Result] = Env1_TMI_Modelling( NumOfPlayer, ETO, PlayerA_idx, PlayerB_idx, CapacityForPlayer, Env1_MINIT, LOASep)
%% Modelling Independent DCB for each player
Env1_Delay = 0;
for player = 1 : NumOfPlayer
    switch player;
        case 1
            [CTO_PlayerA, Delay_PlayerA]    = Model_TMI_MINIT( ETO(PlayerA_idx), LOASep, Env1_MINIT(player), CapacityForPlayer(player) );
            Env1_Delay                      = Env1_Delay + Delay_PlayerA;
        case 2
            [CTO_PlayerB, Delay_PlayerB]    = Model_TMI_MINIT( ETO(PlayerB_idx), LOASep, Env1_MINIT(player), CapacityForPlayer(player) );
            Env1_Delay                      = Env1_Delay + Delay_PlayerB;
    end % switch player;
end % for player
Env1_CTO = sort( [CTO_PlayerA, CTO_PlayerB] );
%% Cat Results
Env1_Result             = struct();
Env1_Result(1).ETO      = ETO;
Env1_Result(1).ETO_A    = ETO(PlayerA_idx);
Env1_Result(1).ETO_B    = ETO(PlayerB_idx);

Env1_Result(1).CTO      = Env1_CTO;
Env1_Result(1).CTO_A    = CTO_PlayerA;
Env1_Result(1).CTO_B    = CTO_PlayerB;

Env1_Result(1).Delay    = Env1_Delay;
end % function [DCB_Scenario]