%{

File:       Env2_TMI_Modelling.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%% Define Function
function [Env2_Result] = Env2_TMI_Modelling( ETO, PlayerA_idx, PlayerB_idx, Scenario_Capacity, Env2_MINIT, LOASep)
%% Modelling Integrated DCB in Once
[Env2_CTO, Env2_Delay]  = Model_TMI_MINIT( ETO, LOASep, Env2_MINIT, Scenario_Capacity );% clc;
%% Cat Results
Env2_Result             = struct();
Env2_Result(1).ETO      = ETO;
Env2_Result(1).ETO_A    = ETO( PlayerA_idx );
Env2_Result(1).ETO_B    = ETO( PlayerB_idx );

Env2_Result(1).CTO      = Env2_CTO;
Env2_Result(1).CTO_A    = Env2_CTO( PlayerA_idx );
Env2_Result(1).CTO_B    = Env2_CTO( PlayerB_idx );

Env2_Result(1).Delay    = Env2_Delay;
end % function