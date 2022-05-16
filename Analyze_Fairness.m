%{

File:       Analyze_Fairness.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%% (1) Load Data
clear all; clc;
saveDir       = 'C:\Users\hyewookkim\Desktop\연구\1 IntATFM\Code\Phase 2\Result';
Env1_FileName = '50_Iter_IndependentATFM';
Env2_FileName = '50_Iter_RegionalATFM';

load(fullfile( saveDir, Env1_FileName ))
load(fullfile( saveDir, Env2_FileName ))
%% (2) Calcuate Mean Delay per Flight(Y-axis) in each Env based on Demand Balance Ratio(X-axis)
% DBR       : Demand Balance Ratio
% MDpF      : Mean Delay per Flight
% MDTF_MDpF : More Delay Traffic Flow's Mean Delay per Flight
% LDTF_MDpF : Less Delay Traffic Flow's Mean Delay per Flight
VariableNames = { 'DBR', 'Demand', 'Demand_A', 'Demand_B', 'MDpF', 'MDpF_A', 'MDpF_B', 'MDTF_MDpF', 'LDTF_MDpF' };
Env1_DBR_Table = array2table( zeros( height( SimResult_Env1 ), numel(VariableNames) ), 'VariableNames', VariableNames );
Env2_DBR_Table = array2table( zeros( height( SimResult_Env1 ), numel(VariableNames) ), 'VariableNames', VariableNames );
for i = 1 : height( SimResult_Env1 )
    Env1_DBR_Table{i,1} = SimResult_Env1{i,5};
    Env1_DBR_Table{i,2} = SimResult_Env1{i,1};
    Env1_DBR_Table{i,3} = SimResult_Env1{i,3};
    Env1_DBR_Table{i,4} = SimResult_Env1{i,4};
    Env1_DBR_Table{i,5} = SimResult_Env1{i,6} / SimResult_Env1{i,1};
    Env1_DBR_Table{i,6} = SimResult_Env1{i,7} / SimResult_Env1{i,3};
    Env1_DBR_Table{i,7} = SimResult_Env1{i,8} / SimResult_Env1{i,4};
    if Env1_DBR_Table{i,3} >= Env1_DBR_Table{i,4}
        Env1_DBR_Table{i,8} = Env1_DBR_Table{i,6};
        Env1_DBR_Table{i,9} = Env1_DBR_Table{i,7};
    else
        Env1_DBR_Table{i,8} = Env1_DBR_Table{i,7};
        Env1_DBR_Table{i,9} = Env1_DBR_Table{i,6};
    end % if Env1_DBR_Table{i,3}

    Env2_DBR_Table{i,1} = SimResult_Env2{i,5};
    Env2_DBR_Table{i,2} = SimResult_Env2{i,1};
    Env2_DBR_Table{i,3} = SimResult_Env2{i,3};
    Env2_DBR_Table{i,4} = SimResult_Env2{i,4};
    Env2_DBR_Table{i,5} = SimResult_Env2{i,6} / SimResult_Env2{i,1};
    Env2_DBR_Table{i,6} = SimResult_Env2{i,7} / SimResult_Env2{i,3};
    Env2_DBR_Table{i,7} = SimResult_Env2{i,8} / SimResult_Env2{i,4};
    if Env2_DBR_Table{i,3} >= Env2_DBR_Table{i,4}
        Env2_DBR_Table{i,8} = Env2_DBR_Table{i,6};
        Env2_DBR_Table{i,9} = Env2_DBR_Table{i,7};
    else
        Env2_DBR_Table{i,8} = Env2_DBR_Table{i,7};
        Env2_DBR_Table{i,9} = Env2_DBR_Table{i,6};
    end % if Env1_DBR_Table{i,3}

end % for i

%% Processssssssssssssssssssssssssssssing
Env1_DBR_Table{:,1} = floor( Env1_DBR_Table{:,1}/10 ) * 10;
Env2_DBR_Table{:,1} = floor( Env2_DBR_Table{:,1}/10 ) * 10;

Env1_DBR_MDpF = [];
Env1_DBR_MDTF_MDpF = [];
Env1_DBR_LDTF_MDpF = [];

Env2_DBR_MDpF = [];
Env2_DBR_MDTF_MDpF = [];
Env2_DBR_LDTF_MDpF = [];

DBR     = Env1_DBR_Table{:,1};
uni_DBR = unique( DBR );

for i = 1 : numel( uni_DBR )
    dbr = uni_DBR(i);
    dbr_idx = find( DBR == dbr);

    Env1_DBR_MDpF       = [ Env1_DBR_MDpF; [dbr, mean(Env1_DBR_Table{dbr_idx, 5})] ];
    Env1_DBR_MDTF_MDpF  = [ Env1_DBR_MDTF_MDpF; [dbr, mean(Env1_DBR_Table{dbr_idx, 8})] ];
    Env1_DBR_LDTF_MDpF  = [ Env1_DBR_LDTF_MDpF; [dbr, mean(Env1_DBR_Table{dbr_idx, 9})] ];

    Env2_DBR_MDpF       = [ Env2_DBR_MDpF; [dbr, mean(Env2_DBR_Table{dbr_idx, 5})] ];
    Env2_DBR_MDTF_MDpF  = [ Env2_DBR_MDTF_MDpF; [dbr, mean(Env2_DBR_Table{dbr_idx, 8})] ];
    Env2_DBR_LDTF_MDpF  = [ Env2_DBR_LDTF_MDpF; [dbr, mean(Env2_DBR_Table{dbr_idx, 9})] ];
end % for i
Env1_DBR_MDpF       = round(Env1_DBR_MDpF);
Env1_DBR_MDTF_MDpF  = round(Env1_DBR_MDTF_MDpF);
Env1_DBR_LDTF_MDpF  = round(Env1_DBR_LDTF_MDpF);

Env2_DBR_MDpF       = round(Env2_DBR_MDpF);
Env2_DBR_MDTF_MDpF  = round(Env2_DBR_MDTF_MDpF);
Env2_DBR_LDTF_MDpF  = round(Env2_DBR_LDTF_MDpF);
%% (3) Plot Histogram
close all;

subplot( 1, 2, 1 )
hold on
plot(Env1_DBR_MDpF(:,1), Env1_DBR_MDpF(:,2), 'k-', 'LineWidth', 5)
plot(Env1_DBR_MDTF_MDpF(:,1), Env1_DBR_MDTF_MDpF(:,2), 'r:', 'LineWidth', 3)
plot(Env1_DBR_LDTF_MDpF(:,1), Env1_DBR_LDTF_MDpF(:,2), 'b:', 'LineWidth', 3)

grid minor
xlabel( 'Demand Balance Ratio (%)', 'FontSize', 15, 'FontWeight', 'bold' )
ylabel( 'Mean Delay per Flight (Min)', 'FontSize', 15, 'FontWeight', 'bold' )
legend( 'Total', 'More Demand Traffic Flow', 'Less Demand Traffic Flow')
xtick = get(gca, 'XTickLabel');
set(gca,'XTickLabel',xtick,'fontsize',15);
title( 'Current ATFM', 'FontSize', 30 )
ylim([0 50])

subplot( 1, 2, 2 )
hold on
plot(Env2_DBR_MDpF(:,1), Env2_DBR_MDpF(:,2), 'k-', 'LineWidth', 5)
plot(Env2_DBR_MDTF_MDpF(:,1), Env2_DBR_MDTF_MDpF(:,2), 'r:', 'LineWidth', 3)
plot(Env2_DBR_LDTF_MDpF(:,1), Env2_DBR_LDTF_MDpF(:,2), 'b:', 'LineWidth', 3)


grid minor
xlabel( 'Demand Balance Ratio (%)', 'FontSize', 15, 'FontWeight', 'bold' )
ylabel( 'Mean Delay per Flight (Min)', 'FontSize', 15, 'FontWeight', 'bold' )
legend( 'Total', 'More Demand Traffic Flow', 'Less Demand Traffic Flow')
xtick = get(gca, 'XTickLabel');
set(gca,'XTickLabel',xtick,'fontsize',15);
title( 'Regional ATFM', 'FontSize', 30 )
ylim([0 50])