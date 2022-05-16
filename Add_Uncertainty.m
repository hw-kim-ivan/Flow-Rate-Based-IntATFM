%{

File:       Add_Uncertainty.m
Purpose:    
Inputs:   
Outputs:
Notes:      

%}

% %% Function Test
% % Env 1
% TMI_Result  = Env1_Result;
% % Env 2
% TMI_Result  = Env2_Result;

%% Define Function
function [TMI_Result] = Add_Uncertainty( TMI_Result, uncertainty_A, uncertainty_B );
TMI_Result.ATO      = [];
TMI_Result.ATO_A    = TMI_Result.CTO_A + uncertainty_A;
TMI_Result.ATO_B    = TMI_Result.CTO_B + uncertainty_B;
TMI_Result.ATO      = sort( [TMI_Result.ATO_A, TMI_Result.ATO_B] );
end % function