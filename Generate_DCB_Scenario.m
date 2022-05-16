%{

File:       Generate_DCB_Scenario.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}
%%

% %% Function Test
% clear all; clc;
% NumOfPlayer = 2;
% MinDemand   = 2;
% MaxDemand   = 10;
% Capacity    = [2:2:10];

%% Define Function
function [DCB_Scenario] = Generate_DCB_Scenario( NumOfPlayer, MinDemand, MaxDemand, Capacity )
DCB_Scenario = [];
for PlayerA_Demand = MinDemand : MaxDemand
    for PlayerB_Demand = MinDemand : MaxDemand
        for Cap_idx = 1 : numel( Capacity )
            Scenario_Demand = sum ( PlayerA_Demand + PlayerB_Demand );
            Scenario_Capacity = Capacity( Cap_idx );
            if Scenario_Demand >= Scenario_Capacity
                PlayerA_Capacity = Scenario_Capacity/2;
                PlayerB_Capacity = Scenario_Capacity/2;
                dcb_scenario  = [ Scenario_Demand, Scenario_Capacity, PlayerA_Demand, PlayerB_Demand, PlayerA_Capacity, PlayerB_Capacity ];
                %% Cat DCB Scenario
                DCB_Scenario  = [DCB_Scenario; dcb_scenario];
            end % if Scenario_Demand >=
        end % for Capacity
    end % for PlayerB
end % for PlayerA
%% Array to Table
DCB_Scenario = array2table( DCB_Scenario, 'VariableNames',{'Scenario_Demand','Scenario_Capacity','A_Demand','B_Demand','A_Capacity','B_Capacity'} );
DCB_Scenario = sortrows( DCB_Scenario, [1 2], {'ascend' 'ascend'} );
end % function