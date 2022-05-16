%{

File:       Plot_Heatmap_2by2.m
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
%% (2) Interpolate Data
[Env1_Demand_X, Env1_Capacity_Y]  = meshgrid( min(SimResult_Env1.Demand):max(SimResult_Env1.Demand), min(SimResult_Env1.Capacity):max(SimResult_Env1.Capacity) );
Env1_Delay_Z        = round( reshape( griddata(SimResult_Env1.Demand, SimResult_Env1.Capacity, SimResult_Env1.Delay, Env1_Demand_X, Env1_Capacity_Y)', 1, [] )' );
Env1_CUR_Z          = round( reshape( griddata(SimResult_Env1.Demand, SimResult_Env1.Capacity, SimResult_Env1.CUR, Env1_Demand_X, Env1_Capacity_Y)', 1, [] )' );
Env1_SepVio_Z       = round( reshape( griddata(SimResult_Env1.Demand, SimResult_Env1.Capacity, SimResult_Env1.SepVio, Env1_Demand_X, Env1_Capacity_Y)', 1, [] )' );
Env1_Demand_X       = round( reshape( Env1_Demand_X', 1, [] )' );
Env1_Capacity_Y     = round( reshape( Env1_Capacity_Y', 1, [] )' );
% % Convert Nan to zero
% Env1_Delay_Z( isnan(Env1_Delay_Z) )     = 0;
% Env1_CUR_Z( isnan(Env1_CUR_Z) )         = 0;
% Env1_SepVio_Z( isnan(Env1_SepVio_Z) )   = 0;
Env1_tbl            = table( Env1_Demand_X, Env1_Capacity_Y, Env1_Delay_Z, Env1_CUR_Z, Env1_SepVio_Z );

[Env2_Demand_X, Env2_Capacity_Y]  = meshgrid( min(SimResult_Env2.Demand):max(SimResult_Env2.Demand), min(SimResult_Env2.Capacity):max(SimResult_Env2.Capacity) );
Env2_Delay_Z        = round( reshape( griddata(SimResult_Env2.Demand, SimResult_Env2.Capacity, SimResult_Env2.Delay, Env2_Demand_X, Env2_Capacity_Y)', 1, [] )' );
Env2_CUR_Z          = round( reshape( griddata(SimResult_Env2.Demand, SimResult_Env2.Capacity, SimResult_Env2.CUR, Env2_Demand_X, Env2_Capacity_Y)', 1, [] )' );
Env2_SepVio_Z       = round( reshape( griddata(SimResult_Env2.Demand, SimResult_Env2.Capacity, SimResult_Env2.SepVio, Env2_Demand_X, Env2_Capacity_Y)', 1, [] )' );
Env2_Demand_X       = round( reshape( Env2_Demand_X', 1, [] )' );
Env2_Capacity_Y     = round( reshape( Env2_Capacity_Y', 1, [] )' );
% % Convert Nan to zero
% Env2_Delay_Z( isnan(Env2_Delay_Z) )     = 0;
% Env2_CUR_Z( isnan(Env2_CUR_Z) )         = 0;
% Env2_SepVio_Z( isnan(Env2_SepVio_Z) )   = 0;
Env2_tbl            = table( Env2_Demand_X, Env2_Capacity_Y, Env2_Delay_Z, Env2_CUR_Z, Env2_SepVio_Z );
%% (3) Plot Heatmap
%% (3-1) Intended ATFM Delay
close all;
tile                    = tiledlayout(3,2);
tile.TileSpacing        = 'compact';
tile.Padding            = 'compact';
tile.Title.String       = 'Current ATFM(Left) v.s. Regional ATFM(Right)';
tile.Title.FontSize     = 35;
tile.Title.FontWeight   = 'bold';
tile.XLabel.String      = 'Demand';
tile.XLabel.FontSize    = 20;
tile.XLabel.FontWeight  = 'bold';
tile.YLabel.String      = 'Capacity';
tile.YLabel.FontSize    = 20;
tile.YLabel.FontWeight  = 'bold';
ValueFontSize           = 20;
MaxVal_Delay            = round( max( [Env1_Delay_Z; Env2_Delay_Z] ), -2 );
MaxVal_CUR              = round( max( [Env1_CUR_Z; Env2_CUR_Z] ), -1 );
MaxVal_SepVio           = round( max( [Env1_SepVio_Z; Env2_SepVio_Z] ), 0 );

nexttile;
Env1_Delay_heatmap                 = heatmap( Env1_tbl, 'Env1_Demand_X', 'Env1_Capacity_Y', 'ColorVariable', 'Env1_Delay_Z', 'MissingDataColor', 'white' );
Env1_Delay_heatmap.Title           = 'Total ATFM Delay(Min)';
Env1_Delay_heatmap.FontSize        = ValueFontSize;
Env1_Delay_heatmap.XLabel          = '';
Env1_Delay_heatmap.YLabel          = '';
Env1_Delay_heatmap.YDisplayData    = flipud( Env1_Delay_heatmap.YDisplayData );
caxis( [0 MaxVal_Delay] )

nexttile;
Env2_Delay_heatmap                 = heatmap( Env2_tbl, 'Env2_Demand_X', 'Env2_Capacity_Y', 'ColorVariable', 'Env2_Delay_Z', 'MissingDataColor', 'white' );
Env2_Delay_heatmap.Title           = 'Total ATFM Delay(Min)';
Env2_Delay_heatmap.FontSize        = ValueFontSize;
Env2_Delay_heatmap.XLabel          = '';
Env2_Delay_heatmap.YLabel          = '';
Env2_Delay_heatmap.YDisplayData    = flipud( Env2_Delay_heatmap.YDisplayData );
caxis( [0 MaxVal_Delay] )
%% Capacity Utilization Ratio
nexttile;
Env1_CUR_heatmap                 = heatmap( Env1_tbl, 'Env1_Demand_X', 'Env1_Capacity_Y', 'ColorVariable', 'Env1_CUR_Z', 'MissingDataColor', 'white', 'Colormap', autumn);
Env1_CUR_heatmap.Title           = 'Capacity Utilization Ratio(%)';
Env1_CUR_heatmap.FontSize        = ValueFontSize;
Env1_CUR_heatmap.XLabel          = '';
Env1_CUR_heatmap.YLabel          = '';
Env1_CUR_heatmap.YDisplayData    = flipud( Env1_CUR_heatmap.YDisplayData );
caxis( [50 MaxVal_CUR] )

nexttile;
Env2_CUR_heatmap                 = heatmap( Env2_tbl, 'Env2_Demand_X', 'Env2_Capacity_Y', 'ColorVariable', 'Env2_CUR_Z', 'MissingDataColor', 'white', 'Colormap', autumn);
Env2_CUR_heatmap.Title           = 'Capacity Utilization Ratio(%)';
Env2_CUR_heatmap.FontSize        = ValueFontSize;
Env2_CUR_heatmap.XLabel          = '';
Env2_CUR_heatmap.YLabel          = '';
Env2_CUR_heatmap.YDisplayData    = flipud( Env2_CUR_heatmap.YDisplayData );
caxis( [50 MaxVal_CUR] )
%% Separation Violation
nexttile;
Env1_SepVio_heatmap                 = heatmap( Env1_tbl, 'Env1_Demand_X', 'Env1_Capacity_Y', 'ColorVariable', 'Env1_SepVio_Z', 'MissingDataColor', 'white', 'Colormap', summer);
Env1_SepVio_heatmap.Title           = 'Separation Violation(#)';
Env1_SepVio_heatmap.FontSize        = ValueFontSize;
Env1_SepVio_heatmap.XLabel          = '';
Env1_SepVio_heatmap.YLabel          = '';
Env1_SepVio_heatmap.YDisplayData    = flipud( Env1_SepVio_heatmap.YDisplayData );
caxis( [0 MaxVal_SepVio] )

nexttile;
Env2_SepVio_heatmap                 = heatmap( Env2_tbl, 'Env2_Demand_X', 'Env2_Capacity_Y', 'ColorVariable', 'Env2_SepVio_Z', 'MissingDataColor', 'white', 'Colormap', summer);
Env2_SepVio_heatmap.Title           = 'Separation Violation(#)';
Env2_SepVio_heatmap.FontSize        = ValueFontSize;
Env2_SepVio_heatmap.XLabel          = '';
Env2_SepVio_heatmap.YLabel          = '';
Env2_SepVio_heatmap.YDisplayData    = flipud( Env2_SepVio_heatmap.YDisplayData );
caxis( [0 MaxVal_SepVio] )