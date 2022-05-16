%{

File:       ModellingTMI_MINIT.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

%%
function [CTO_MINIT, Delay_MINIT] = Modelling_TMI_MINIT( ETO, MinSep, MINIT, Capacity )

NumOfPlan = numel( ETO );
%% Opimization Problem
prob            = optimproblem( 'ObjectiveSense','minimize' );
CTO             = optimvar( 'CTO', 1, NumOfPlan, 'Type', 'integer' );
prob.Objective  = sum( CTO - ETO );
options         = optimoptions( 'linprog', 'Display', 'none' );
%% Constraint#1 -> CTOT shouldn't be less than the corresponding ETOT
Constraint_1 = optimconstr( NumOfPlan, 1 );
for con1_idx = 1 : NumOfPlan
    Constraint_1(con1_idx) = ETO( con1_idx ) <= CTO( con1_idx );
end;
%% Constraint#2 -> The interval of CTOT shouldn't be less than LOA separataion
Constraint_2 = optimconstr( NumOfPlan-1, 1 );
for con2_idx = 1 : NumOfPlan-1
    Constraint_2(con2_idx) = CTO( con2_idx+1 ) - CTO( con2_idx ) >= MinSep;
end;
%% Constraint#3 -> CTOT should meet MINIT interval
Constraint_3 = optimconstr(NumOfPlan-1,1);
for con3_idx = 1:NumOfPlan-1
    Constraint_3(con3_idx) = CTO( con3_idx+1 ) - CTO( con3_idx ) >= MINIT;
end;
% % Set of constraints
% show(Constraint_1)
% show(Constraint_2)
% show(Constraint_3)
%% Solve the probelm
prob.Constraints.Constraint_1 = Constraint_1;
prob.Constraints.Constraint_2 = Constraint_2;
prob.Constraints.Constraint_3 = Constraint_3;
%
CTO         = solve( prob, 'Options', options );
CTO_MINIT   = CTO.CTO;
%% Total ATFM Delay
Delay_MINIT = sum( CTO_MINIT - ETO );

end % function



