%{

File:       Caculate_CapacityUtilizationRatio.m
Purpose:    Generate Demand-Capacity Scenario based on the input MinMax Demand.
Inputs:   
Outputs:    Array of DCB Scenarios
Notes:      [Total_Demand, Total_Capacity, PlayerA_Demand, PlayerB_Demand, PlayerC_Demand, PlayerA_Capacity, PlayerB_Capacity, PlayerC_Capacity]  

%}

% %% Function Test
% clear all; clc;
% ATO      = [3.6285 9.4716 30.6815 53.7924 64.8713 69.4916 82.4780 129.1401 134.3249 187.7828 246.5548 309.6330];
% Capacity = 4;

%% Define Function
function CapacityUtilizationRatio = Caculate_CapacityUtilizationRatio( ATO, Capacity)
CUR_idx = 0 : floor( ATO(end)/60 );
CUR_list = arrayfun( @(x) numel( find(ATO>=x*60 & ATO<(x+1)*60) ), CUR_idx) / Capacity;

if numel(CUR_list) > 1
    CapacityUtilizationRatio = mean( CUR_list(1:end-1) );
else
    CapacityUtilizationRatio = CUR_list;
end % if numel(CUR_list) > 1

end % function