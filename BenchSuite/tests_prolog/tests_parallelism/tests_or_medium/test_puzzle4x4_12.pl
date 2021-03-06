%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_puzzle4x4_12.pl
%% Added by: Ricardo Rocha
%% Program:  4x4 board puzzle problem, writen by Ricardo Rocha 1996
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(puzzle4x4(X)),
             fail.

debug_query:- parallel_findall(X,puzzle4x4(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%   board configuration
%%   -------------------
%%   | P11 P12 P13 P14 |
%%   | P21 P22 P23 P24 |
%%   | P31 P32 P33 P34 |
%%   | P41 P42 P43 P44 |
%%   -------------------
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

puzzle4x4(X):- pz4x4(12,X).

pz4x4(N,S):- pz4x4_problem(N,Y), pz4x4_solve(N,Y,S).

pz4x4_problem(10,[ 1, 2, 3, 8,
            5, 6,11, 7,
           13, 9,10,16,
            o,14,12,15]).

pz4x4_problem(11,[ o, 2, 3, 8,
            1, 6,11, 7,
            5, 9,10,16,
           13,14,12,15]).

pz4x4_problem(12,[ 2, o, 3, 8,
            1, 6,11, 7,
            5, 9,10,16,
           13,14,12,15]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pz4x4_movimento(1,0).
pz4x4_movimento(2,1).
pz4x4_movimento(3,2).
pz4x4_movimento(4,3).
pz4x4_movimento(5,4).
pz4x4_movimento(6,5).
pz4x4_movimento(7,6).
pz4x4_movimento(8,7).
pz4x4_movimento(9,8).
pz4x4_movimento(10,9).
pz4x4_movimento(11,10).
pz4x4_movimento(12,11).

pz4x4_solve(_,[ 1, 2, 3, o,
          5, 6, 7, 8,
          9,10,11,12,
         13,14,15,16],[]).

pz4x4_solve(N,       [P11,  o,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m11|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[  o,P11,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                  o,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m11|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[  o,P12,P13,P14,
                P11,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [  o,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m12|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P12,  o,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,  o,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m12|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,  o,P12,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,  o,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m12|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,  o,P13,P14,
                P21,P12,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,  o,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m13|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P13,  o,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).
 
pz4x4_solve(N,       [P11,P12,P13,  o,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m13|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,  o,P13,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,  o,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m13|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,  o,P14,
                P21,P22,P13,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,  o,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m14|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P14,  o,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,  o,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m14|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,  o,
                P21,P22,P23,P14,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [  o,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m21|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P21,P12,P13,P14,
                  o,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,  o,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m21|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                  o,P21,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                  o,P32,P33,P34,
                P41,P42,P43,P44],[m21|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                  o,P22,P23,P24,
                P21,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,  o,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m22|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P22,P13,P14,
                P21,  o,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                  o,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m22|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P22,  o,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,  o,P33,P34,
                P41,P42,P43,P44],[m22|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,  o,P23,P24,
                P31,P22,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,  o,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m22|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,  o,P22,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,  o,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m23|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P23,P14,
                P21,P22,  o,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,  o,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m23|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P23,  o,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,  o,P34,
                P41,P42,P43,P44],[m23|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,  o,P24,
                P31,P32,P23,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,  o,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m23|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,  o,P23,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,  o,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m24|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P24,
                P21,P22,P23,  o,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,  o,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m24|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P24,  o,
                P31,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,  o,
                P41,P42,P43,P44],[m24|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,  o,
                P31,P32,P33,P24,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                  o,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m31|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P31,P22,P23,P24,
                  o,P32,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,  o,P33,P34,
                P41,P42,P43,P44],[m31|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                  o,P31,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                  o,P42,P43,P44],[m31|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                  o,P32,P33,P34,
                P31,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,  o,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m32|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P32,P23,P24,
                P31,  o,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                  o,P32,P33,P34,
                P41,P42,P43,P44],[m32|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P32,  o,P33,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,  o,P34,
                P41,P42,P43,P44],[m32|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,  o,P32,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,  o,P43,P44],[m32|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,  o,P33,P34,
                P41,P32,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,  o,P24,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m33|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P33,P24,
                P31,P32,  o,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,  o,P33,P34,
                P41,P42,P43,P44],[m33|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P33,  o,P34,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,  o,
                P41,P42,P43,P44],[m33|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,  o,P33,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,  o,P44],[m33|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32, o,P34,
                P41,P42,P33,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,  o,
                P31,P32,P33,P34,
                P41,P42,P43,P44],[m34|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P34,
                P31,P32,P33,  o,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,  o,P34,
                P41,P42,P43,P44],[m34|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P34,  o,
                P41,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,  o],[m34|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,  o,
                P41,P42,P43,P34],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                  o,P32,P33,P34,
                P41,P42,P43,P44],[m41|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P41,P32,P33,P34,
                  o,P42,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,  o,P43,P44],[m41|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                  o,P41,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,  o,P33,P34,
                P41,P42,P43,P44],[m42|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P42,P33,P34,
                P41,  o,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                  o,P42,P43,P44],[m42|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P42,  o,P43,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,  o,P44],[m42|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,  o,P42,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,  o,P34,
                P41,P42,P43,P44],[m43|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P43,P34,
                P41,P42,  o,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,  o,P43,P44],[m43|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P43,  o,P44],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P43,  o],[m43|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,  o,P43],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,  o,
                P41,P42,P43,P44],[m44|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P44,
                P41,P42,P43,  o],L).

pz4x4_solve(N,       [P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,  o,P44],[m44|L]):-
      pz4x4_movimento(N,N1), 
      pz4x4_solve(N1,[P11,P12,P13,P14,
                P21,P22,P23,P24,
                P31,P32,P33,P34,
                P41,P42,P44,  o],L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
