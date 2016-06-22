%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      mode_bprolog.pl
%% Author(s): 
%% Program:   General settings/predicates for BPROLOG mode
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Compatibility preds                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set_value(X,Y) :- global_set(X,Y).
get_value(X,Y) :- global_get(X,Y).

atomic_list_concat([X,Y], Z) :- 
	term2atom(Y,Y1),
	atom_concat(X,Y1,Z).

tabling_statistics :- statistics.
tabling_statistics(total_memory, [B,_]) :- statistics(table,B).
round_time(Time, TimeSum, N):- Time is floor(TimeSum / N). 
adjust_to_ms(Time,NTime):- NTime is floor(Time).
thread_self(0).
show_global_trie.
show_all_tables(_).
show_all_tries.
abolish_all_tables :- initialize_table.
:- set_value(default_stdout,0).

time_compatible(_,runtime). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     mode_common.pl                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- ['mode_common.pl'].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
