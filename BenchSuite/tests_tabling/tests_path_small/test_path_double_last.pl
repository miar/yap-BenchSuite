%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_path_double_last.pl
%% Added by: Miguel Areias and Ricardo Rocha
%% Program:  Double recursive path definition 
%%           with the recursive clause last
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

path(X,Z):- edge(X,Z).
path(X,Z):- path(X,Y), path(Y,Z).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
