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
saveDir         = 'C:\Users\hyewookkim\Desktop\연구\1 IntATFM\Code\Phase 2\Result'; % Input your own dir
NumOfPlayer     = 2;
MinDemand       = 2;            % per Player 4-20
MaxDemand       = 7;            % per Player
Capacity        = [4:2:14];     % on Fix
LOASep          = 6;
NumOfIter       = 50;
idx             = 1;
%% (1) Generate DCB Scenarios
[DCB_Scenario]  = Generate_DCB_Scenario( NumOfPlayer, MinDemand, MaxDemand, Capacity );
VariableNames   = {'Demand', 'Capacity', 'Demand_A', 'Demand_B', 'DemandBalanceRatio', 'Delay', 'Delay_A', 'Delay_B',...
    'CUR','CUR_A','CUR_B','SepVio','SepVio_A','SepVio_B'};
SimResult_Env1  = array2table( zeros( height(DCB_Scenario), numel(VariableNames) ), 'VariableNames', VariableNames );
SimResult_Env2  = array2table( zeros( height(DCB_Scenario), numel(VariableNames) ), 'VariableNames', VariableNames );
for Scene_Num = 1 : height( DCB_Scenario )
    DCB_scenario        = table2array( DCB_Scenario( Scene_Num, : ) );
    Scenario_Demand     = DCB_scenario(1);
    Scenario_Capacity   = DCB_scenario(2);
    DemandForPlayer     = DCB_scenario(3:4);
    DemandBalanceRatio  = round((1-(abs(DemandForPlayer(1)-DemandForPlayer(2))/Scenario_Demand))*100);
    CapacityForPlayer   = DCB_scenario(5:6);
    Env1_Result_Stack   = zeros(1, 9);
    Env2_Result_Stack   = zeros(1, 9);
    for iter = 1 : NumOfIter
        fprintf( '[Processing] SCENARIO #%d out of #%d   ITERATION #%d out of #%d    \n', Scene_Num, height(DCB_Scenario), iter, NumOfIter );
        %% (2) Submit FPL -> Generate ETO
        [ETO, PlayerA_idx, PlayerB_idx] = Submit_FPL( DemandForPlayer, NumOfPlayer );
        %% (3) Modeling TMI (MINIT & Flow-rate based TMI) -> Generate CTO
        Env1_MINIT = round( 60./ CapacityForPlayer );
        Env2_MINIT = round( 60/ Scenario_Capacity );

        [Env1_Result] = Env1_TMI_Modelling( NumOfPlayer, ETO, PlayerA_idx, PlayerB_idx, CapacityForPlayer, Env1_MINIT, LOASep);
        [Env2_Result] = Env2_TMI_Modelling( ETO, PlayerA_idx, PlayerB_idx, Scenario_Capacity, Env2_MINIT, LOASep);
        %% (4) Add Operation(G.T & F.T) Uncertainty -> Generate ATO
        uncertainty_A = normrnd( 2, 2, 1, DemandForPlayer(1) ); % Parent A
        uncertainty_B = normrnd( 4, 4, 1, DemandForPlayer(2) ); % Parent B

        [Env1_Result] = Add_Uncertainty( Env1_Result, uncertainty_A, uncertainty_B );
        [Env2_Result] = Add_Uncertainty( Env2_Result, uncertainty_A, uncertainty_B );
        %% (5) Compute Metrics from simulation results /Env1 & Env2/
        % (5-1) Total ATFM Delay (CTO-ETO)
        Env1_Delay              = sum( Env1_Result.CTO - Env1_Result.ETO );
        Env1_Delay_A            = sum( Env1_Result.CTO_A - Env1_Result.ETO_A );
        Env1_Delay_B            = sum( Env1_Result.CTO_B - Env1_Result.ETO_B );
        Env1_Delay_Set          = [ Env1_Delay, Env1_Delay_A, Env1_Delay_B ];

        Env2_Delay              = sum( Env2_Result.CTO - Env2_Result.ETO );
        Env2_Delay_A            = sum( Env2_Result.CTO_A - Env2_Result.ETO_A );
        Env2_Delay_B            = sum( Env2_Result.CTO_B - Env2_Result.ETO_B );
        Env2_Delay_Set          = [ Env2_Delay, Env2_Delay_A, Env2_Delay_B ];
        % (5-2) Capacity Utilization Ratio (CUR)
        Env1_CUR        = Caculate_CUR( Env1_Result.ATO, Scenario_Capacity );
        Env1_CUR_A      = Caculate_CUR( Env1_Result.ATO_A, CapacityForPlayer(1) );
        Env1_CUR_B      = Caculate_CUR( Env1_Result.ATO_B, CapacityForPlayer(2) );

        Env2_CUR        = Caculate_CUR( Env2_Result.ATO, Scenario_Capacity );
        Env2_CUR_A      = Caculate_CUR( Env2_Result.ATO_A, CapacityForPlayer(1) );
        Env2_CUR_B      = Caculate_CUR( Env2_Result.ATO_B, CapacityForPlayer(2) );
        % (5-3) Separation Violation (SepVio)
        Env1_SepVio     = numel( find( diff( Env1_Result.ATO ) < LOASep ) );
        Env1_SepVio_A   = numel( find( diff( Env1_Result.ATO_A ) < LOASep ) );
        Env1_SepVio_B   = numel( find( diff( Env1_Result.ATO_B ) < LOASep ) );

        Env2_SepVio     = numel( find( diff( Env2_Result.ATO ) < LOASep ) );
        Env2_SepVio_A   = numel( find( diff( Env2_Result.ATO_A ) < LOASep ) );
        Env2_SepVio_B   = numel( find( diff( Env2_Result.ATO_B  ) < LOASep ) );
        %% (6) Stack Result of each Iteration /Env1 & Env2/
        Env1_Result_Stack   = Env1_Result_Stack + [ Env1_Delay_Set, Env1_CUR, Env1_CUR_A, Env1_CUR_B, Env1_SepVio, Env1_SepVio_A, Env1_SepVio_B ];
        Env2_Result_Stack   = Env2_Result_Stack + [ Env2_Delay_Set, Env2_CUR, Env2_CUR_A, Env2_CUR_B, Env2_SepVio, Env2_SepVio_A, Env2_SepVio_B ];
        clc;
    end % iter = 1:10
    %% (6) Stack Result of Entire Simulation /Env1 & Env2/
    SimResult_Env1{idx, :} = [ Scenario_Demand, Scenario_Capacity, DemandForPlayer, DemandBalanceRatio, round( Env1_Result_Stack/NumOfIter, 1) ];
    SimResult_Env2{idx, :} = [ Scenario_Demand, Scenario_Capacity, DemandForPlayer, DemandBalanceRatio, round( Env2_Result_Stack/NumOfIter, 1) ];

    idx = idx + 1;
end % for Scene_Num
%% (7) Save
Env1_FileName   = strcat( num2str(NumOfIter), '_Iter_IndependentATFM.mat' );
Env2_FileName   = strcat( num2str(NumOfIter), '_Iter_RegionalATFM.mat' );

save( fullfile( saveDir, Env1_FileName ), 'SimResult_Env1', '-v7.3', '-nocompression' )
save( fullfile( saveDir, Env2_FileName ), 'SimResult_Env2', '-v7.3', '-nocompression' )

fprintf( '[Saving] Done;) ' ); toc;