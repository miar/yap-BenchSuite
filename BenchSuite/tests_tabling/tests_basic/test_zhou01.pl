%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_zhou01.pl
%% Added by: Miguel Areias and Ricardo Rocha
%% Program:  Example taken from one of Zhou's paper
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- p(X,Y),
             fail.

debug_query:- p(X,Y),
              query_output([X, ' - ', Y, '\n']),
              fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- table p/2.
:- table q/2.
tabled_predicate(p/2).
tabled_predicate(q/2).

p(X,Y):- q(X,Y).

q(X,Y):- p(X,Z), t(Z,Y).
q(a,b).

t(b,c).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
