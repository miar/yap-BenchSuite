%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_hamiltonian_graphs.pl
%% Added by: Ricardo Rocha
%% Program:  Hamiltonian graphs
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(ham(X)),
             fail.

debug_query:- parallel_findall(X,ham(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ham(H):- cycle_ham([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z],H).

cycle_ham([X|Y],[X,T|L]) :-
	chain_ham([X|Y],[],[T|L]),
	ham_edge(T,X).

chain_ham([X],L,[X|L]).
chain_ham([X|Y],K,L) :-
	ham_del(Z,Y,T),
	ham_edge(X,Z),
	chain_ham([Z|T],[X|K],L).

ham_del(X,[X|Y],Y).
ham_del(X,[U|Y],[U|Z]) :- ham_del(X,Y,Z).

ham_edge(X,Y) :-
	ham_connect(X,L),
	ham_el(Y,L).

ham_el(X,[X|_]).
ham_el(X,[_|L]) :- ham_el(X,L).

ham_connect(a,[b,n,m]).
ham_connect(b,[c,a,u]).
ham_connect(c,[d,b,o]).
ham_connect(d,[e,c,v]).
ham_connect(e,[f,d,p]).
ham_connect(f,[g,e,w]).
ham_connect(g,[h,f,q]).
ham_connect(h,[i,g,x]).
ham_connect(i,[j,h,r]).
ham_connect(j,[k,i,y]).
ham_connect(k,[l,j,s]).
ham_connect(l,[m,k,z]).
ham_connect(m,[a,l,t]).
ham_connect(n,[o,a,t]).
ham_connect(o,[p,n,c]).
ham_connect(p,[q,o,e]).
ham_connect(q,[r,p,g]).
ham_connect(r,[s,q,i]).
ham_connect(s,[t,r,k]).
ham_connect(t,[s,m,n]).
ham_connect(u,[v,z,b]).
ham_connect(v,[w,u,d]).
ham_connect(w,[x,v,f]).
ham_connect(x,[y,w,h]).
ham_connect(y,[z,x,j]).
ham_connect(z,[y,l,u]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
