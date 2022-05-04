%{
    File:       Adapatation.m
    Purpose:    Initialize variables in the project.
    Inputs:   
    Outputs:
    Notes:        
%}
%%
function [CTO_aar, Delay_aar] = ModellingTMI_FRbT_BiObj(ETO, LOA_sep, adj_capacity)
adj_capacity = 4;
ETO = GenerateETO_Randperm(8);
LOA_sep = 6;
%%
num_plan = numel(ETO);
%%
if num_plan <= adj_capacity
    CTO_aar = ETO;
    Delay_aar = sum(CTO_aar - ETO);
else
    %% << Define Opimization Problem >>
    % Bi-Objective Function
    fun = @(CTO)[sum( CTO-ETO ), sum( diff(CTO) )];
    % Optmization option
    lb = zeros(1, num_plan);
    intcon = 1 : num_plan;
    options = optimoptions('gamultiobj', 'UseParallel', true, 'UseVectorized',false, 'MaxGenerations', 10);

    %% (3.1) Constraint#1 -> CTOT shouldn't be less than the corresponding ETOT
    Constraint_1A = zeros(num_plan, num_plan);
    for col = 1 : num_plan
        Constraint_1A(col, col) = -1;
    end % for col = 1:nvars
    Constraint_1b = -1 * ETO';

    %% (3.2) Constraint#2 -> The interval of CTOT shouldn't be less than LOA separataion
    Constraint_2A = zeros(num_plan-1, num_plan);
    for col = 1 : num_plan-1
        Constraint_2A(col, [col:col+1]) = [1, -1];
    end % for col = 1 : num_plan-1
    Constraint_2b = -LOA_sep * ones(num_plan-1, 1);

    %% (3.3) Constraint#3 -> Flow rate TMI should meet the AAR condition
    Constraint_3num = ceil(num_plan/capacity);
    Constraint_3A = zeros(Constraint_3num-1, num_plan);
    for col = 2 : Constraint_3num
        idx = capacity * (col-1) + 1;
        Constraint_3A(col-1, idx) = 1;
    end
    Constraint_3b = 60*[1 : Constraint_3num-1]';

    %% (3.4) Aggregate all constraints
    Constraint_A = [Constraint_1A; Constraint_2A; Constraint_3A];
    Constraint_b = [Constraint_1b; Constraint_2b; Constraint_3b];

    %% Solve optimization problem
    [CTO, ~, ~, ~] = gamultiobj(fun, num_plan, Constraint_A, Constraint_b, [], [], lb, [], [], intcon, options);
    Delay_aar = sum(CTO-ETO, 2);
end % if num_plan <= adj_capacity
end % function [CTO_aar, Delay_aar]



