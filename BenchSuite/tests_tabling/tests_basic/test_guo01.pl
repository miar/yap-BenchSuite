%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_guo01.pl
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

r(X,Y):- r(X,Z), p(Z,Y).
r(X,Y):- p(X,Y).
r(X,Y):- r(X,Z), q(Z,Y).

p(a,b).
p(b,c).

q(c,d).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
