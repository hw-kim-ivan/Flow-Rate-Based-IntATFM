%{

File:       Caculate_CapacityUtilizationRatio.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% clear all; clc;
% ATO      = [3.6285 9.4716 30.6815 53.7924 64.8713 69.4916 82.4780 129.1401 134.3249 187.7828 246.5548 309.6330];
% Capacity = 4;

%% Define Function
function CapacityUtilizationRatio = Caculate_CapacityUtilizationRatio( ATO, Capacity)
CUR_idx     = 0 : floor( ATO(end)/60 );
CUR_list    = arrayfun( @(x) numel( find(ATO>=x*60 & ATO<(x+1)*60) ), CUR_idx) / Capacity;
if numel(CUR_list) > 1
    CapacityUtilizationRatio = mean( CUR_list(1:end-1) );
else
    CapacityUtilizationRatio = CUR_list;
end % if numel(CUR_list) > 1
CapacityUtilizationRatio = CapacityUtilizationRatio * 100;
end % function