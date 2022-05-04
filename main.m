%{

File:       Main.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%%
clear all; clc; close all; tic; warning( 'off', 'all' );
%% (0) Initialize Variables
saveDir         = ; % Input your own dir
NumOfPlayer     = 3;
MinDemand       = 3;
MaxDemand       = 6;
Capacity        = [4, 8, 12];
LOASep          = 6;
NumOfIter       = 10;
SimResult_Env1  = [];
SimResult_Env2  = [];
idx             = 1;
%% (1) Generate DCB Scenarios
[DCB_Scenario] = Generate_DCB_Scenario( NumOfPlayer, MinDemand, MaxDemand, Capacity );
for Scene_Num = 1 : height( DCB_Scenario )
    DCB_scenario        = table2array( DCB_Scenario(Scene_Num, :) );
    Scenario_Demand     = DCB_scenario(1);
    Scenario_Capacity   = DCB_scenario(2);
    Demand_for_Player   = DCB_scenario(3:5);
    Capacity_for_Player = DCB_scenario(6:8);
    Env1_Result_Stack   = zeros(1, 6);
    Env2_Result_Stack   = zeros(1, 6);
    for iter = 1 : NumOfIter
        fprintf( 'Processing...Scenario# %d Out of #%d...Iter# %d Out of #%d \n', Scene_Num, height(DCB_Scenario), iter, NumOfIter );
        %% (2) Submit FPL -> Generate ETO
        [ETO, Player_idx, PlayerA_idx, PlayerB_idx, PlayerC_idx] = Submit_FPL( [], Demand_for_Player, NumOfPlayer );
        %% (3) Modeling TMI (MINIT & Flow-rate based TMI) -> Generate CTO
        Env1_MINIT = round( 60./ Capacity_for_Player );
        Env2_MINIT = round( 60/ Scenario_Capacity );
        % Env1/Independant ATFM
        [Env1_Result] = Env1_TMI_Modelling( [], [], [], 0, 0, NumOfPlayer, ETO, Player_idx, Capacity_for_Player, Env1_MINIT, LOASep);
        % Env2/Regional ATFM
        [Env2_Result] = Env2_TMI_Modelling( [], [], [], 0, 0, ETO, Scenario_Capacity, Env2_MINIT, LOASep);
        %% (4) Add Operation(G.T & F.T) Uncertainty -> Generate ATO
        uncertainty_A = normrnd( 3, 3, 1, Demand_for_Player(1) ); % Parent A
        uncertainty_B = normrnd( 2, 2, 1, Demand_for_Player(2) ); % Parent B
        uncertainty_C = normrnd( 4, 4, 1, Demand_for_Player(3) ); % Child C of Parent B
        % Env1/Independant ATFM
        [Env1_ATO_MINIT, Env1_ATO_FRbT] = Env1_Add_Uncertainty( Env1_Result.CTO_MINIT, Env1_Result.CTO_FRbT, uncertainty_A, uncertainty_B, uncertainty_C );
        % Env2/Regional ATFM
        [Env2_ATO_MINIT, Env2_ATO_FRbT] = Env2_Add_Uncertainty( Env2_Result.CTO_MINIT, Env2_Result.CTO_FRbT, Player_idx, uncertainty_A, uncertainty_B, uncertainty_C );
        %% (5) Compute Metrics from simulation results /Env1 & Env2/
        %% (5-1) Total ATFM Delay (Delay)
        Env1_Delay_MINIT    = Env1_Result.Delay_MINIT;
        Env1_Delay_FRbT     = Env1_Result.Delay_FRbT;
        Env2_Delay_MINIT    = Env2_Result.Delay_MINIT;
        Env2_Delay_FRbT     = Env2_Result.Delay_FRbT;
        %% (5-2) Capacity Utilization Ratio (CUR)
        Env1_CUR_MINIT      = Caculate_CapacityUtilizationRatio( Env1_ATO_MINIT, Scenario_Capacity );
        Env1_CUR_FRbT       = Caculate_CapacityUtilizationRatio( Env1_ATO_FRbT, Scenario_Capacity );
        Env2_CUR_MINIT      = Caculate_CapacityUtilizationRatio( Env2_ATO_MINIT, Scenario_Capacity );
        Env2_CUR_FRbT       = Caculate_CapacityUtilizationRatio( Env2_ATO_FRbT, Scenario_Capacity );
        %% (5-3) Separation Violation (SepVio)
        Env1_SepVio_MINIT   = numel( find( diff(Env1_ATO_MINIT) < LOASep ) );
        Env1_SepVio_FRbT    = numel( find( diff(Env1_ATO_FRbT) < LOASep ) );
        Env2_SepVio_MINIT   = numel( find( diff(Env2_ATO_MINIT) < LOASep ) );
        Env2_SepVio_FRbT    = numel( find( diff(Env2_ATO_FRbT) < LOASep ) );
        %% (6) Stack Result of each Iteration /Env1 & Env2/
        Env1_Result_Stack   = Env1_Result_Stack + [ Env1_Delay_MINIT, Env1_Delay_FRbT, Env1_CUR_MINIT, Env1_CUR_FRbT, Env1_SepVio_MINIT, Env1_SepVio_FRbT ];
        Env2_Result_Stack   = Env2_Result_Stack + [ Env2_Delay_MINIT, Env2_Delay_FRbT, Env2_CUR_MINIT, Env2_CUR_FRbT, Env2_SepVio_MINIT, Env2_SepVio_FRbT ];
        clc;
    end % iter = 1:10
    %% (6) Stack Result of Entire Simulation /Env1 & Env2/
    SimResult_Env1(idx).Demand              = Scenario_Demand;
    SimResult_Env1(idx).Capacity            = Scenario_Capacity;
    SimResult_Env1(idx).Delay_MINIT         = Env1_Result_Stack(1) / NumOfIter;
    SimResult_Env1(idx).Delay_FRbT          = Env1_Result_Stack(2) / NumOfIter;
    SimResult_Env1(idx).CapUtilRatio_MINIT  = Env1_Result_Stack(3) / NumOfIter;
    SimResult_Env1(idx).CapUtilRatio_FRbT   = Env1_Result_Stack(4) / NumOfIter;
    SimResult_Env1(idx).SepVio_MINIT        = Env1_Result_Stack(5) / NumOfIter;
    SimResult_Env1(idx).SepVio_FRbT         = Env1_Result_Stack(6) / NumOfIter;

    SimResult_Env2(idx).Demand              = Scenario_Demand;
    SimResult_Env2(idx).Capacity            = Scenario_Capacity;
    SimResult_Env2(idx).Delay_MINIT         = Env2_Result_Stack(1) / NumOfIter;
    SimResult_Env2(idx).Delay_FRbT          = Env2_Result_Stack(2) / NumOfIter;
    SimResult_Env2(idx).CapUtilRatio_MINIT  = Env2_Result_Stack(3) / NumOfIter;
    SimResult_Env2(idx).CapUtilRatio_FRbT   = Env2_Result_Stack(4) / NumOfIter;
    SimResult_Env2(idx).SepVio_MINIT        = Env2_Result_Stack(5) / NumOfIter;
    SimResult_Env2(idx).SepVio_FRbT         = Env2_Result_Stack(6) / NumOfIter;

    idx = idx + 1;
end % for Scene_Num
%% (7) Save
Env1_FileName   = strcat( 'IndependentATFM_', num2str(NumOfIter), 'iter.mat' );
Env2_FileName   = strcat( 'RegionalATFM_', num2str(NumOfIter), 'iter.mat' );

save( fullfile( saveDir, Env1_FileName ), 'Env1_Result', '-v7.3', '-nocompression' )
save( fullfile( saveDir, Env2_FileName ), 'Env2_Result', '-v7.3', '-nocompression' )