%{

File:       GenerateETO_Randperm.m
Purpose:    Generate Demand-Capacity Scenario based on the input MinMax Demand.
Inputs:   
Outputs:    Array of DCB Scenarios
Notes:      [Total_Demand, Total_Capacity, PlayerA_Demand, PlayerB_Demand, PlayerC_Demand, PlayerA_Capacity, PlayerB_Capacity, PlayerC_Capacity]  

%}

%% Define Function
function ETO = GenerateETO_Randperm( Demand )
ETO = sort( randperm(60, Demand) - 1 );
end % function