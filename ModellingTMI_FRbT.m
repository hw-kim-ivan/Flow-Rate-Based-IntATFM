%{

File:       ModellingTMI_FRbT.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% clear all; clc;
% ETO         = [3 6 21 22 33 37 41 43 51];
% MinSep      = 6;
% Capacity    = 4;

%% Define Function
function [CTO_FRbT, Delay_FRbT] = ModellingTMI_FRbT( ETO, MinSep, Capacity )
NumofPlan = numel( ETO );
if NumofPlan <= Capacity
    CTO_FRbT    = ETO;
    Delay_FRbT  = sum( CTO_FRbT - ETO );
else
    %% Opimization Problem
    prob            = optimproblem( 'ObjectiveSense','minimize' );
    CTO             = optimvar( 'CTO', 1, NumofPlan, 'Type', 'integer' );
    prob.Objective  = sum( CTO - ETO );
    options         = optimoptions( 'linprog', 'Display', 'none' );
    %% Constraint#1 -> CTOT shouldn't be less than the corresponding ETOT
    Constraint_1 = optimconstr( NumofPlan, 1 );
    for con1_idx = 1 : NumofPlan
        Constraint_1(con1_idx) = ETO( con1_idx ) <= CTO( con1_idx );
    end;
    %% Constraint#2 -> The interval of CTOT shouldn't be less than LOA separataion
    Constraint_2 = optimconstr( NumofPlan-1, 1 );
    for con2_idx = 1 : NumofPlan-1
        Constraint_2(con2_idx) = CTO( con2_idx+1 ) - CTO( con2_idx ) >= MinSep;
    end;
    %% Constraint#3 -> Flow rate TMI should meet the AAR condition
    Constraint_3 = optimconstr( ceil(NumofPlan/Capacity), 1 );
    for con3_idx = 2 : ceil( NumofPlan/Capacity )
        idx = Capacity*( con3_idx-1 ) + 1;
        Constraint_3(con3_idx) = CTO( idx ) >= 60*( con3_idx - 1 );
    end;
    % % Check Constraints
    % show(Constraint_1)
    % show(Constraint_2)
    % show(Constraint_3)
    %% Solve the equation
    prob.Constraints.Constraint_1 = Constraint_1;
    prob.Constraints.Constraint_2 = Constraint_2;
    prob.Constraints.Constraint_3 = Constraint_3;
    %
    CTO        = solve( prob, 'Options', options );
    CTO_FRbT   = CTO.CTO;
    %% Total ATFM Delay
    Delay_FRbT = sum( CTO_FRbT - ETO );
end % if NumofPlan

end % function
