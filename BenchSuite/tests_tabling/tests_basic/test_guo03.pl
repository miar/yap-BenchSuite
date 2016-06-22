%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_guo03.pl
%% Added by: Miguel Areias and Ricardo Rocha
%% Program:  Example taken from one of Guo's paper
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- r(a,X),
             fail.

debug_query:- r(a,X),
              query_output([X, '\n']),
              fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- table r/2.
tabled_predicate(r/2).

r(X,Y):- p(X,Z), r(Z,Y).
r(X,Y):- p(X,Y).

p(a,b).
p(b,a).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
