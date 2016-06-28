%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_map_colouring_15.pl
%% Added by: Ricardo Rocha
%% Program:  Map colouring problem from Kish Shen's thesis
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(map(X)),
             fail.

debug_query:- parallel_findall(X,map(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

map(M):- map_problem(15,M),
         map_colours(C),
         colour_map(M,C).

map_problem(15,[country(pa,PA,[TO,MA,AM,RR,AP]),
               country(am,AM,[AC,RR,RO,MT,RN]),
               country(ac,AC,[AM]),
               country(rn,RO,[AM]),
               country(ro,RR,[PA,AM]),
               country(ap,AP,[PA]),
               country(to,TO,[PA,MA]),
               country(ma,MA,[TO,PA,PI]),
               country(pi,PI,[MA,CE,PE]),
	       country(ce,CE,[PI,RN,PB]),
	       country(rn,RN,[CE,PB]),
	       country(pb,PB,[RN,PE,CE]),
	       country(pe,PE,[PB,CE,PI,AL]),
	       country(al,AL,[PE,SE]),
	       country(se,SE,[BA,AL])]).

map_problem(17,[country(pa,PA,[TO,MA,AM,RR,AP]),
               country(am,AM,[AC,RR,RO,MT,RN]),
               country(ac,AC,[AM]),
               country(rn,RO,[AM]),
               country(ro,RR,[PA,AM]),
               country(ap,AP,[PA]),
	       country(to,TO,[PA,MA,BA]),
	       country(ma,MA,[TO,PA,PI]),
	       country(pi,PI,[MA,CE,PE,BA]),
	       country(ce,CE,[PI,RN,PB]),
	       country(rn,RN,[CE,PB]),
	       country(pb,PB,[RN,PE,CE]),
	       country(pe,PE,[PB,CE,PI,AL,BA]),
	       country(al,AL,[PE,SE]),
	       country(se,SE,[BA,AL]),
	       country(ba,BA,[SE,PI,PE,TO]),
	       country(mg,MG,[BA])]).

map_problem(26,[country(pa,PA,[TO,MA,AM,RR,AP,MT]),
               country(am,AM,[AC,RR,RO,MT,RN]),
               country(ac,AC,[AM]),
               country(rn,RO,[AM,MT]),
               country(ro,RR,[PA,AM]),
               country(ap,AP,[PA]),
	       country(to,TO,[PA,MA,MT,DF,BA]),
	       country(ma,MA,[TO,PA,PI]),
	       country(pi,PI,[MA,CE,PE,BA]),
	       country(ce,CE,[PI,RN,PB]),
	       country(rn,RN,[CE,PB]),
	       country(pb,PB,[RN,PE,CE]),
	       country(pe,PE,[PB,CE,PI,AL,BA]),
	       country(al,AL,[PE,SE]),
	       country(se,SE,[BA,AL]),
	       country(ba,BA,[SE,PI,PE,TO,DF,MG,ES]),
	       country(mg,MG,[ES,RJ,SP,DF,BA]),
	       country(es,ES,[RJ,BA,MG]),
	       country(rj,RJ,[ES,MG,SP]),
	       country(sp,SP,[RJ,MG,PR,MS]),
	       country(pr,PR,[SP,MS,SC]),
	       country(sc,SC,[PR,RS]),
	       country(rs,RS,[SC]),
	       country(ms,MS,[PR,SP,DF,MT]),
	       country(df,DF,[BA,TO,MG,MS,MT]),
	       country(mt,MT,[MS,DF,TO,PA,RO,AM])]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

map_colours([red, green, blue]).

colour_map([],_).
colour_map([Country|Map], Colourlst) :-
    colour_country(Country, Colourlst),
    colour_map(Map, Colourlst).

colour_country(country(_,C,AdjacentCs), Colourlst) :-
    map_del(C, Colourlst, CL),
    map_subset(AdjacentCs, CL).

map_subset([],_).
map_subset([C|Cs], Colourlst) :-
    map_del(C, Colourlst, _),
    map_subset(Cs, Colourlst).

map_del(X, [X|L], L).
map_del(X, [Y|L1], [Y|L2] ) :-
    map_del(X, L1, L2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
