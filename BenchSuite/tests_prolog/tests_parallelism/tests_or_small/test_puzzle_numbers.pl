%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_puzzle_numbers.pl
%% Added by: Ricardo Rocha
%% Program:  A puzzle problem with numbers
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(puzzle_solution(X)),
             fail.

debug_query:- parallel_findall(X,puzzle_solution(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% The numbers 1 to 19 are going to be placed in this pattern:
%%
%%      a,b,c,
%%     d,e,f,g,
%%    h,i,j,k,l,
%%     m,n,o,p,
%%      q,r,s
%%
%% so that the sums in all 15 diagonals are equal
%% a+b+c = d+e+f+g = ... = a+d+h = b+e+i+m = ... = c+g+l = b+f+k+p = ...
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

puzzle_solution([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S]) :-   
  List=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],
  puzzle_member(A,List,La), puzzle_member(B,La,Lb),
  C is 38-A-B, puzzle_member(C,Lb,Lc),
  A < C,
  puzzle_member(D,Lc,Ld), H is 38-A-D, puzzle_member(H,Ld,Lh),
  A < H, C < H,
  puzzle_member(E,Lh,Le), puzzle_member(F,Le,Lf), G is 38-D-E-F, puzzle_member(G,Lf,Lg),
  L is 38-C-G, puzzle_member(L,Lg,Ll),
  A < L,
  puzzle_member(I,Ll,Li), M is 38-B-E-I, puzzle_member(M,Li,Lm),
  Q is 38-H-M, puzzle_member(Q,Lm,Lq),
  A < Q,
  puzzle_member(J,Lq,Lj), N is 38-C-F-J-Q, puzzle_member(N,Lj,Ln),
  K is 38-H-I-J-L, puzzle_member(K,Ln,Lk),
  P is 38-B-F-K, puzzle_member(P,Lk,Lp),
  S is 38-L-P, puzzle_member(S,Lp,Ls),
  A < S,
  R is 38-Q-S, puzzle_member(R,Ls,Lr), 38 is D+I+N+R,
  puzzle_member(O,Lr,_Lo), 38 is M+N+O+P, 38 is A+E+J+O+S, 38 is G+K+O+R.

puzzle_member(X,[X|Y],Y).
puzzle_member(X,[X2|Y],[X2|Y2]) :- X \== X2, puzzle_member(X,Y,Y2). 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
