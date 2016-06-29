%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_path_left_first.pl
%% Added by: Miguel Areias and Ricardo Rocha
%% Program:  Left recursive path definition 
%%           with the recursive clause first
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- path(X,Y),
             fail.

debug_query:- path(X,Y),
              query_output([X, ' - ', Y, '\n']),
              fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- table path/2.
tabled_predicate(path/2).

path(X,Z):- path(X,Y), edge(Y,Z).
path(X,Z):- edge(X,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
