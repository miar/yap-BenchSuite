%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_cubes_7.pl
%% Added by: Ricardo Rocha
%% Program:  N-Cubes or Instant Insanity problem from E. Tick book 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(cubes(X)),
             fail.

debug_query:- parallel_findall(X,cubes(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cubes(Sol):- cubes(7,Qs), solve(Qs,[],Sol).

cubes(7,[q(p(5,1),p(0,5),p(3,1)),
	 q(p(2,3),p(1,4),p(4,0)),
         q(p(3,6),p(0,0),p(2,4)),
	 q(p(6,4),p(6,1),p(0,1)),
	 q(p(1,5),p(3,2),p(5,2)),
	 q(p(5,0),p(2,3),p(4,5)),
	 q(p(4,2),p(2,6),p(0,3))]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve([],Rs,Rs).
solve([C|Cs],Ps,Rs):-
   set(C,P),
   check(Ps,P),
   solve(Cs,[P|Ps],Rs).

check([],_).
check([q(A1,B1,C1,D1)|Ps],P):-
   P = q(A2,B2,C2,D2),
   A1 =\= A2, B1 =\= B2, C1 =\= C2, D1 =\= D2,
   check(Ps,P).

set(q(P1,P2,P3),P):- rotate(P1,P2,P).
set(q(P1,P2,P3),P):- rotate(P2,P1,P).
set(q(P1,P2,P3),P):- rotate(P1,P3,P).
set(q(P1,P2,P3),P):- rotate(P3,P1,P).
set(q(P1,P2,P3),P):- rotate(P2,P3,P).
set(q(P1,P2,P3),P):- rotate(P3,P2,P).

rotate(p(C1,C2),p(C3,C4),q(C1,C2,C3,C4)).
rotate(p(C1,C2),p(C3,C4),q(C1,C2,C4,C3)).
rotate(p(C1,C2),p(C3,C4),q(C2,C1,C3,C4)).
rotate(p(C1,C2),p(C3,C4),q(C2,C1,C4,C3)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
