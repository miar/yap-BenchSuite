%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_leader01.pl
%% Added by: José Vieira and Ricardo Rocha
%% Program:  Tests a situation where the leader changes during 
%%           the fix-point loop
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- t(1,X),
             fail.

debug_query:- t(1,X), 
              query_output([X, '\n']),
              fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- table t/2.
tabled_predicate(t/2).

t(1,X):- a(X).
t(2,X):- t(3,X).
t(3,X):- t(2,Y), t(1,X).
t(3,a).

a(X):- t(2,X).
a(b).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
