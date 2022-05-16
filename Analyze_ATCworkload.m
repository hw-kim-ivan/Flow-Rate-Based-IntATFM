%{

File:       Analyzie_ATCWorkload.m
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
%% (2) Preprocess Data
Env1_SepVio     = SimResult_Env1.SepVio;
Env1_SepVio_A   = SimResult_Env1.SepVio_A;
Env1_SepVio_B   = SimResult_Env1.SepVio_B;
Env2_SepVio     = SimResult_Env2.SepVio;
Env2_SepVio_A   = SimResult_Env2.SepVio_A;
Env2_SepVio_B   = SimResult_Env2.SepVio_B;

[Env1_SepVio, Env1_idx] = sort( Env1_SepVio );
Env1_SepVio_A           = Env1_SepVio_A( Env1_idx );
Env1_SepVio_B           = Env1_SepVio_B( Env1_idx );
Env1_SepVio_AB          = Env1_SepVio - (Env1_SepVio_A + Env1_SepVio_B);

[Env2_SepVio, Env2_idx] = sort( Env2_SepVio );
Env2_SepVio_A           = Env2_SepVio_A( Env2_idx );
Env2_SepVio_B           = Env2_SepVio_B( Env2_idx );
Env2_SepVio_AB          = Env2_SepVio - (Env2_SepVio_A + Env2_SepVio_B);
%% Plot Line Graph
close all;
subplot( 1, 2, 1 )
hold on
plot( Env1_SepVio, 'k-', 'LineWidth', 3 )
plot( Env1_SepVio_A, 'r:', 'LineWidth', 3 )
plot( Env1_SepVio_B, 'b:', 'LineWidth', 3 )

grid minor
xlabel( 'Scenario #', 'FontSize', 15, 'FontWeight', 'bold' )
ylabel( '# of Separation Violation', 'FontSize', 15, 'FontWeight', 'bold' )
legend( 'Arrival', 'Departure A', 'Departure B')
xtick = get(gca, 'XTickLabel');
set(gca,'XTickLabel',xtick,'fontsize',15);
title( 'Current ATFM', 'FontSize', 30 )
ylim([0 10])

subplot( 1, 2, 2 )
hold on
plot( Env2_SepVio, 'k-', 'LineWidth', 3 )
plot( Env2_SepVio_A, 'r:', 'LineWidth', 3 )
plot( Env2_SepVio_B, 'b:', 'LineWidth', 3 )

grid minor
xlabel( 'Scenario #', 'FontSize', 15, 'FontWeight', 'bold' )
ylabel( '# of Separation Violation', 'FontSize', 15, 'FontWeight', 'bold' )
legend( 'Arrival', 'Departure A', 'Departure B')
xtick = get(gca, 'XTickLabel');
set(gca,'XTickLabel', xtick,'fontsize',15);
title( 'Regional ATFM', 'FontSize', 30 )
ylim([0 10])
%% Plot Stacked Bar Graph
Num = round( numel(Env1_SepVio_A)/2 );
Env1 = [ Env1_SepVio_A(Num:end), Env1_SepVio_B(Num:end), Env1_SepVio_AB(Num:end) ];
Env2 = [ Env2_SepVio_A(Num:end), Env2_SepVio_B(Num:end), Env2_SepVio_AB(Num:end) ];

close all;
subplot( 1, 2, 1 )
Env1_bar = bar( Env1, 'stacked' )
Env1_bar(3).FaceColor = [.2 .6 .5];
grid minor
xlabel( 'Scenario #', 'FontSize', 15, 'FontWeight', 'bold' )
ylabel( '# of Separation Violation', 'FontSize', 15, 'FontWeight', 'bold' )
legend( 'Between Departure A', 'Between Departure B', 'Between Departure A and B')
xtick = get(gca, 'XTickLabel');
set(gca,'XTickLabel',xtick,'fontsize',15);
title( 'Current ATFM', 'FontSize', 30 )
ylim([0 10])

subplot( 1, 2, 2 )
Env2_bar = bar( Env2, 'stacked' )
Env2_bar(3).FaceColor = [.2 .6 .5];
grid minor
xlabel( 'Scenario #', 'FontSize', 15, 'FontWeight', 'bold' )
ylabel( '# of Separation Violation', 'FontSize', 15, 'FontWeight', 'bold' )
legend( 'Between Departure A', 'Between Departure B', 'Between Departure A and B')
xtick = get(gca, 'XTickLabel');
set(gca,'XTickLabel', xtick,'fontsize',15);
title( 'Regional ATFM', 'FontSize', 30 )
ylim([0 10])