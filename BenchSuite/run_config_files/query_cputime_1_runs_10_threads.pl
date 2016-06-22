%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     
%% Author(s):
%% Program:  
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%run_query :- run_query(walltime(runs(1),threads(0))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


run_query :- run_query(set_info(tabling_total_memory)).
run_query :- run_query(results([solutions,tables],runs(1),threads(2))).
run_query :- run_query(misc(tabling_statistics)).
run_query :- run_query(debug(abolish_tables)).
run_query :- run_query(debug(tabling_total_memory)).
