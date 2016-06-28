%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_nsort_11.pl
%% Added by: Ricardo Rocha
%% Program:  Naive sort program from Delgado-Rannauro's thesis
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(nsort(X)),
             fail.

debug_query:- parallel_findall(X,nsort(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsort(L):- go_nsort([11,10,9,8,7,6,5,4,3,2,1],L).

go_nsort(L1,L2):-
    nsort_permutation(L1,L2),
    nsort_sorted(L2).

nsort_sorted([X,Y|Z]):-
    X =< Y,
    nsort_sorted([Y|Z]).
nsort_sorted([_]).

nsort_permutation([],[]).
nsort_permutation(L,[H|T]):-
    nsort_delete(H,L,R),
    nsort_permutation(R,T).

nsort_delete(X,[X|T],T). 
nsort_delete(X,[Y|T],[Y|T1]):- nsort_delete(X,T,T1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
