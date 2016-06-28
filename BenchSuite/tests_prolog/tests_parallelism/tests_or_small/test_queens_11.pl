%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_queens_11.pl
%% Added by: Ricardo Rocha
%% Program:  Queens on a 12x12 chess board problem
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(queens(X)),
             fail.

debug_query:- parallel_findall(X,queens(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

queens(S) :- size(BoardSize), solve(BoardSize,[],S).

size(11).

snint(1).
snint(2).
snint(3).
snint(4).
snint(5).
snint(6).
snint(7).
snint(8).
snint(9).
snint(10).
snint(11).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

newsquare([square(I,J)|Rest],square(X,Y)) :-
       X is I+1,
       snint(Y),
       not_threatened(I,J,X,Y),
       safe(X,Y,Rest).
newsquare([],square(1,X)) :- snint(X).

safe(X,Y,[square(I,J)|L]) :-
       not_threatened(I,J,X,Y),
       safe(X,Y,L).
safe(X,Y,[]).

not_threatened(I,J,X,Y) :-
       I =\= X,
       J =\= Y,
       I-J =\= X-Y,
       I+J =\= X+Y.

solve(Board_size,Initial,Final) :-
       newsquare(Initial,Next),
       solve(Board_size,[Next|Initial],Final).
solve(Bs,[square(Bs,Y)|L],[square(Bs,Y)|L]) :- size(Bs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
