%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_single03.pl
%% Added by: Ricardo Rocha
%% Program:  Tests the use of the table_try_single instruction
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- t(X),
             fail.

debug_query:- t(X), 
              query_output([X, '\n']),
              fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- table t/1.
:- table a/0.
:- table b/0.
tabled_predicate(t/1).
tabled_predicate(a/0).
tabled_predicate(b/0).

t(1):- a, a.

a:- b.

b.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
