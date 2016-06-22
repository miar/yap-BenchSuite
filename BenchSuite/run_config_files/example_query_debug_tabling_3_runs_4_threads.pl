%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      example_query_debug_tabling_3_runs_4_threads.pl
%% Author(s): Ricardo Rocha
%% Program:   Query file for debugging tabled programs
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query :- run_query(set_info(tabling_total_memory)).
run_query :- run_query(results([solutions,tables],runs(3),threads(4))).
run_query :- run_query(misc(tabling_statistics)).
run_query :- run_query(debug(abolish_tables)).
run_query :- run_query(debug(tabling_total_memory)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
