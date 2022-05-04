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
% NumOfPlayer = 3;
% MinDemand   = 3;
% MaxDemand   = 6;
% Capacity    = [4, 8, 12];

%% Define Function
function [DCB_Scenario] = Generate_DCB_Scenario( NumOfPlayer, MinDemand, MaxDemand, Capacity )
DCB_Scenario = [];
for PlayerA = MinDemand : MaxDemand
    for PlayerB = MinDemand : MaxDemand
        for PlayerC = MinDemand : MaxDemand
            for Cap_idx = 1 : 3
                capacity_list = [Capacity(Cap_idx)/2, Capacity(Cap_idx)/4, Capacity(Cap_idx)/4];
                dcb_scenario  = [ PlayerA + PlayerB + PlayerC, sum(capacity_list), PlayerA, PlayerB, PlayerC, capacity_list ];
                %% Cat DCB Scenario
                DCB_Scenario  = [DCB_Scenario; dcb_scenario];
            end % for Capacity
        end % for PlayerC
    end % for PlayerB
end % for PlayerA
%% Array to Table
DCB_Scenario = array2table( DCB_Scenario, 'VariableNames',{'Scenario_Demand','Scenario_Capacity','A_Demand','B_Demand','C_Demand','A_Capacity','B_Capacity','C_Capacity'} );
DCB_Scenario = sortrows( DCB_Scenario, 1 );
end % function