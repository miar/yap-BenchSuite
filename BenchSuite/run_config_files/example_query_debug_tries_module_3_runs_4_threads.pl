%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      example_query_debug_tries_module_3_runs_4_threads.pl
%% Author(s): Ricardo Rocha
%% Program:   Query file for debugging the tries module
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query :- run_query(results([solutions,tries],runs(3),threads(4))).
run_query :- run_query(debug(abolish_tries)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
