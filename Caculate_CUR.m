%{

File:       Caculate_CapacityUtilizationRatio.m
Purpose:    Generate Demand-Capacity Scenario based on the input MinMax Demand.
Inputs:   
Outputs:    Array of DCB Scenarios
Notes:      [Total_Demand, Total_Capacity, PlayerA_Demand, PlayerB_Demand, PlayerC_Demand, PlayerA_Capacity, PlayerB_Capacity, PlayerC_Capacity]  

%}

% %% Function Test
% % Scenario Test
% ATO      = Env1_Result.ATO;
% Capacity = Scenario_Capacity;
% % Player Test
% ATO      = Env1_Result.ATO_B;
% Capacity = CapacityForPlayer(1);

%% Define Function
function CUR = Caculate_CUR( ATO, Capacity )
CUR_idx = 0 : floor( ATO(end)/60 );
CUR_list = arrayfun( @(x) numel( find(ATO>=x*60 & ATO<(x+1)*60) ), CUR_idx) / Capacity;

if numel(CUR_list) > 1
    CUR = mean( CUR_list(1:end-1) );
else
    CUR = CUR_list;
end % if numel(CUR_list) > 1

CUR = round( CUR*100 );
end % function