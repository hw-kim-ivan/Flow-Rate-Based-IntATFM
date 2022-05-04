%{

File:       Adapatation.m
Purpose:    Initialize variables in the project.
Inputs:   
Outputs:
Notes:        

%}
%%
function [Each_Demand, Each_Capacity] = Distributor( N_plyaer, Total_Demand, Total_Capacity );
%% Initiallize Variables
Each_Demand = zeros( 1, N_plyaer );
Each_Capacity = zeros( 1, N_plyaer );
%% Distribute Demand to each player
Demand_flag = 1;
while Demand_flag
    Each_Demand = randi( round(Total_Demand), 1, N_plyaer );
    if ( sum(Each_Demand) == Total_Demand ) & ( max(Each_Demand) - min(Each_Demand) <= 1 )
        Demand_flag = 0;
    end % if
end % while
%% Distribute Capacity to each player
Capacity_flag = 1;
while Capacity_flag
    Each_Capacity = randi( round(Total_Capacity), 1, N_plyaer );
    if ( sum(Each_Capacity) == Total_Capacity ) & ( max(Each_Capacity) - min(Each_Capacity) <= 1 )
        Capacity_flag = 0;
    end % if
end % while
%% Distribute bigger capacity to bigger demander
Each_Demand = sort( Each_Demand );
Each_Capacity = sort( Each_Capacity );
end % function