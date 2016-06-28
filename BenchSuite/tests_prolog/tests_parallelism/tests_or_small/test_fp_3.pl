%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:     test_fp_3.pl
%% Added by: Ricardo Rocha
%% Program:  Floor planner problem
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_query:- parallel(fp(X)),
             fail.

debug_query:- parallel_findall(X,fp(X),L),
              parallel_findall_query_output(L),
              fail.

parallel_findall_query_output([]) :- !.
parallel_findall_query_output([H|T]) :-
              query_output([H, '\n']),
              parallel_findall_query_output(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fp(S):- fp(3,S).

fp(1,S) :- 
	floor_length(FL), floor_width(FW),
        assert(v_line1(room(0,14,0,8),4)),
	L=[(hall,4,6),(kitchen,8,10),(bathroom,6,6), (bedroom,15,16),
	   (name(living,1),20,28),(name(living,2),16,20),
	   (name(room,1),12,16),(name(room,2),10,12),(name(room,3),9,10)], 
 	RQ=[(kitchen,windowd,west),(kitchen,windowd,north),
	    (hall,windowd,north),(name(living,_),windowd,south),
	    (bathroom,windowd,north)], 
	floor(room(0,FL,0,FW),L,S,RQ),  
	find((kitchen,RK),S), find((hall,RH),S), adjacent(RK,RH),
	find((bedroom,RB),S), find((bathroom,RBA),S), adjacent(RB,RBA), 
        not ident_disorder(S,L).

fp(2,S) :-
        floor_length(FL), floor_width(FW),
        assert(v_line1(room(0,14,0,8),4)),
	assert(h_line1(room(0,14,0,8),0)),
	L=[(hall,4,6),(kitchen,8,10),(bathroom,6,6), (bedroom,15,16),
 	   (name(living,1),20,28),(name(living,2),16,20),(name(room,1),12,16),
	   (name(room,2),10,12),(name(room,3),9,10)],
	RQ=[(kitchen,windowd,west),(kitchen,windowd,north),
	    (hall,windowd,north),(name(living,_),windowd,south),
	    (bathroom,windowd,north)], 
	floor(room(0,FL,0,FW),L,S,RQ),  
	find((kitchen,RK),S), find((hall,RH),S), adjacent(RK,RH),
	find((bedroom,RB),S), find((bathroom,RBA),S), adjacent(RB,RBA), 
	not ident_disorder(S,L).

fp(3,S) :-
        floor_length(FL), floor_width(FW),
        assert(v_line1(room(0,14,0,8),4)),
	L=[(hall,4,6),(passage_h,8,12),(kitchen,8,10),(bathroom,6,6), 
	   (bedroom,15,16), (name(living,1),20,24),(name(living,2),12,16),
	   (name(room,1),12,12),(name(room,2),8,10),(name(room,3),8,10)], 
	make_sol_temp(L, Pattern), 
	RQ=[(kitchen,windowd,west),(kitchen,windowd,north),
	    (hall,windowd,north),(name(living,_),windowd,south)],
	floor(room(0,FL,0,FW),L,S,RQ),
   	find((kitchen,RK),S), find((name(living,1),RL1),S),
	find((name(living,2),RL2),S),find((hall,RH),S),
	find((passage_h,RPA),S),
	adjacent(RH,RPA),(adjacent(RK,RL1);adjacent(RK,RL2)),
	not ident_disorder(S,L),
	extract_sol(S, ES).

sol_temp(Pattern):- sol_temp1(Pattern), !.

make_sol_temp(Rooms, Pattern):- 
	extract_sort_names(Rooms, [], Pattern),
	assert(sol_temp1(Pattern)).

extract_sort_names( [], P1,P2) :- sort(P1,P2).
extract_sort_names([(N,_,_) | Ns], ENs, P) :-
	extract_sort_names( Ns, [N | ENs], P) .

extract_sol(Sol, ESol) :-
	sort(Sol, Sol2), 
	sol_temp(Pattern),
	extract_sol2(Sol2, ESol, Pattern).

extract_sol2([], [], []).
extract_sol2([(Name, room(A,B,C,D)) | RSol2], [(A,B,C,D) | RESol], [Name | Names]) :-
	extract_sol2( RSol2, RESol,  Names).

expand_sol(ESol, Sol) :-
	sol_temp(Pattern),
	extract_sol2(Sol, ESol, Pattern).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

floor_length(14).  
floor_width(8).

shaped(bedroom, [5,2]).
shaped(name(living,_), [5,2]).  
shaped(name(room,_), [5,2]).
shaped(kitchen, [6,2]).  

light_source(vertical(0)).  
light_source(vertical(14)).
light_source(horizontal(0)).  
light_source(horizontal(8)).

natural_light(nat(name(room,_),2,1)).
natural_light(nat(name(living,_),3,2)).

fixed_room((hall,room(4,6,_,_))).  
fixed_room((passage_h,room(4,_,_,_))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-op(900,fx,not).
:-dynamic v_line1/2,
          h_line1/2,
          no_v_line1/2,
          no_h_line1/2,
          sol_temp1/1.

/* floor(R,L,S,REQ) R:floor rectangle L:room reqest list S:solution REQ:further requests */

floor(R,[RS],SOL,_) :- 
     fit(R,RS), RS=(NAME,_,_), not violated1(NAME,R), 
       SOL=[(NAME,R)] .
floor(R,L,SOL,REQ) :- 
     L=[_|T], not T=[], join(R,R1,R2), area(R1,A1), area(R2,A2), 
       merge(L,L1,L2,A1,A2,R1,R2,REQ), not L1=[], not L2=[], 
       max_demand(L1,AL1), AL1>=A1, max_demand(L2,AL2), AL2>=A2, 
       floor(R1,L1,SOL1,REQ), not parallel_disorder(R1,R2,SOL1), 
       floor(R2,L2,SOL2,REQ), not vertical_cross(R1,SOL1,R2,SOL2), 
       appended(SOL,SOL1,SOL2) .

/* L is a merge of room request lists L1 and L2, such that   */
/* L1 and L2 have total min area reqests =< A1 and A2 resp.  */
/* further REQuests can be satisfied in rectangles R1 and R2 */

merge(L,L1,L2,A1,A2,R1,R2,REQ) :- 
     merge(L,L1,L2,A1,A2,R1,R2,REQ,0,0) .

merge([],[],[],_,_,_,_,_,_,_) .
merge([U|L],L1,[U|L2],A1,A2,R1,R2,REQ,B1,B2) :- 
     U=(NAME,A,_), A+B2=<A2, B2A is B2+A, 
       not violated(R2,NAME,REQ), 
       merge(L,L1,L2,A1,A2,R1,R2,REQ,B1,B2A) .
merge([U|L],[U|L1],L2,A1,A2,R1,R2,REQ,B1,B2) :- 
     U=(NAME,A,_), A+B1=<A1, B1A is B1+A, 
       not violated(R1,NAME,REQ), 
       merge(L,L1,L2,A1,A2,R1,R2,REQ,B1A,B2) .

max_demand(L,A) :- 
     max_demand(L,A,0) .

max_demand([],A,A) .
max_demand([(_,_,N)|L],A,A1) :- 
     A2 is A1+N, max_demand(L,A,A2) .

join(room(X0,X1,Y0,Y1),room(X0,X,Y0,Y1),room(X,X1,Y0,Y1)) :- 
     v_line(room(X0,X1,Y0,Y1),X),in_between(X,X0,X1),
	 			not no_v_line1(room(X0,X1,Y0,Y1),X). 
join(room(X0,X1,Y0,Y1),room(X0,X1,Y0,Y),room(X0,X1,Y,Y1)) :- 
     v_line(room(X0,X1,Y0,Y1),Y),in_between(Y,Y0,Y1),
					not no_h_line1(room(X0,X1,Y0,Y1),Y).

v_line(R,X):- v_line1(R,X), !.
v_line(_,_).
h_line(R,X):- h_line1(R,X), !.
h_line(_,_).				

bounds(X0,X1,Y0,Y1,MIN1,MAX1,MIN2,MAX2,U,V) :- 
     D is Y1-Y0, DM is - D, U1 is X0-MIN1 // DM, 
       U2 is X1+MAX2 // DM, max([U1,U2],U), V1 is X0+MAX1 // D, 
       V2 is X1-MIN2 // D, min([V1,V2],V), U=<V .

in_between(I,U,V) :- 
     in_between(I,U,V,U,V) .

in_between(I,U,V,U1,V1) :- 
     minwall(MW), increment(INC), V1>U1+INC, I is U1+INC, 
       I-U>=MW, V-I>=MW .
in_between(I,U,V,U1,V1) :- 
     minwall(MW), increment(INC), V1>U1+2*INC, U2 is U1+INC, 
       V-U2-INC>=MW, in_between(I,U,V,U2,V1) .

/* violated1(NAME,R): a rule is violated for room NAME if located in rectangle R */
/* Rule1: length/width =< P/Q                                                     */

violated1(passage_h,room(_,_,Y1,Y2)) :-Y2-Y1>2.
violated1(NAME,R) :- 
     shaped(NAME,[P,Q]), not shape(R,P,Q) .
violated1(NAME,R) :- 
	natural_light(nat(NAME,P,Q)), not enough_light(R,P,Q).
violated1(NAME,R) :-
	fixed_room((NAME, RR)), not R=RR.

enough_light(room(X1,X2,Y1,Y2),P,Q):-
	(light_source(vertical(X1)) ; light_source(vertical(X2))),
	(X2-X1)/(Y2-Y1)=<P/Q
	 ; (light_source(horizontal(Y1)) ; light_source(horizontal(Y2))),
		(Y2-Y1)/(X2-X1)=<P/Q.				

/* does room R fit into room size request RS */

fit(R,RS) :- 
     area(R,A), RS=(_,A1,A2), A1=<A, A=<A2 .

violated(R,NAME,RQ) :- 
     member2((NAME,TYPE,Z),RQ), not satisfy(TYPE,R,Z) .

satisfy(windowd,R,DIR) :- 
     windowd(R,DIR) .

find(R,[R|_]) .
find(R,[R1|L]) :- 
     not R=R1, find(R,L) .

append3([],L,L) .
append3([U|L1],L2,L) :- 
     append3(L1,[U|L2],L) .

appended(L,[],L) .
appended(L,[U|L1],L2) :- 
     appended(L,L1,[U|L2]) .

not_member2(_,[]) .
not_member2(U,[V|L]) :- 
     not U = V, not_member2(U,L) .

area(R,A) :- 
     not R=[_|_], area([R],0,A) .
area(R,A) :- 
     R=[_|_], area(R,0,A) .

area([],A,A) .
area([room(X0,X1,Y0,Y1)|L],A,B) :- 
     A1 is A+(X1-X0)*(Y1-Y0), area(L,A1,B) .

/* windowd orientation, north: Y+ */

windowd(room(0,_,_,_),west) .
windowd(room(_,Z,_,_),east) :- 
     floor_length(Z) .
windowd(room(_,_,0,_),north) .
windowd(room(_,_,_,Z),south) :- 
     floor_width(Z) .

/* shape of a room is an upper bound on its length/width */

shape(room(X0,X1,Y0,Y1),P,Q) :- 
     Q*(Y1-Y0)=<P*(X1-X0), Q*(X1-X0)=<P*(Y1-Y0) .

prob :- 
     vertical_cross(room(0,6,0,2),[(e,room(0,3,0,2)),(liv1,room(3
         ,6,0,2))],room(0,6,2,4),[(s,room(0,3,2,4)),(liv2,room(3,
         6,2,4))]) .

/* not_square is a lower bound on length/width of the room */

not_square(room(X0,X1,Y0,Y1),P,Q) :- 
     Q*(Y1-Y0)>=P*(X1-X0);
     Q*(X1-X0)>=P*(Y1-Y0) .

/* long_room requires a minimum length P */

long_room(room(X0,X1,Y0,Y1),P) :- 
     Y1-Y0>=P;
     X1-X0>=P .

/* two rooms are adjacent if they have a door size common wall */

adjacent(R,R) .
adjacent(room(X0,X1,Y0,Y1),room(U0,U1,V0,V1)) :- 
     neighbour(X0,X1,U0,U1), common_wall(Y0,Y1,V0,V1);
     neighbour(Y0,Y1,V0,V1), common_wall(X0,X1,U0,U1) .

neighbour(_,W,W,_) .
neighbour(W,_,_,W) .

common_wall(W0,W1,Z0,Z1) :- 
     max([W0,Z0],MX), min([W1,Z1],MN), door_size(D), MN-MX>=D .

/* max/min element of list L: MX/MN */

max(L,MX) :- 
     L=[M|L1], max(L1,M,MX), ! .

max([],M,M) .
max([U|L],M,MM) :- 
     U=<M, max(L,M,MM);
     U>M, max(L,U,MM) .

min(L,MN) :- 
     L=[M|L1], min(L1,M,MN), ! .

min([],M,M) .
min([U|L],M,MM) :- 
     U>=M, min(L,M,MM);
     U<M, min(L,U,MM) .

/* not_reachable(L1,L2,L3,L) inp: L1,L2,L3  out:L, all room lists  */
/* L:the sublist of L3, that cannot be reached from any room of L1 */
/* without going through at least one of rooms of L2               */

not_reachable(L1,L2,L3,L) :- 
     not_reachable(L1,L2,[],L3,L) .

not_reachable([],_,_,L,L) .
not_reachable([U|L],LN,LR,LA,LL) :- 
     adjacent_to(U,LA,LAA,LAN), remove_all(LN,LAA,LAB), 
       append3(LAB,L,LAC), append3(U,LR,LR1), 
       not_reachable(LAC,LN,LR1,LAN,LL) .

adjacent_to(U,L,LA,LN) :- 
     adjacent_to(U,L,[],[],LA,LN) .

adjacent_to(_,[],L1,L2,L1,L2) .
adjacent_to(X,[U|L],L1,L2,LA,LN) :- 
     if_adjacent(X,U,L1,L2,L11,L22), 
       adjacent_to(X,L,L11,L22,LA,LN) .

if_adjacent(X,U,L1,L2,[U|L1],L2) :- 
     adjacent(X,U),! .
if_adjacent(_,U,L1,L2,L1,[U|L2]) .

/* horizontal-vertical disorder. R1 is under R2 */

vertical_cross(R1,SOL1,R2,SOL2) :- 
     not SOL1=[_], not SOL2=[_], horizontal(R1,R2), 
       vertical(R1,SOL1,R2,SOL2) .

horizontal(room(_,_,_,Z),room(_,_,Z,_)) .

vertical(R1,SOL1,R2,SOL2) :- 
     g_start(vertic,R1,SOL1,S), g_list(vertic,S,SOL1,[],L1), 
     g_next(vertic,R1,S,L1,F), g_list(vertic,F,SOL2,[],L2), 
     g_next(vertic,R2,F,L2,_) .

/* left-right, bottom-up lexicographic disorder      */
/* R1,R2 fitting rectangles SOL1 subrectangles of R1 */

parallel_disorder(R1,R2,SOL1) :- 
     direction(R1,R2,DIR), parallel(DIR,R1,SOL1) .

direction(room(X0,X1,_,_),room(X0,X1,_,_),horiz) .
direction(room(_,_,Y0,Y1),room(_,_,Y0,Y1),vertic) .

/* parallel: in rectangle R there is a Guillotine line parallel to D */

parallel(D,R,L) :- 
     g_start(D,R,L,S), g_list(D,S,L,[],L1), g_next(D,R,S,L1,_) .

/* g_start(D,R,L,S): S is a rectangle on list L containing */
/* a potential first interval of a Guillotine line         */
/* of rectangle R in direction D                           */

g_start(horiz,R,[S|_],S) :- 
     R=room(X,_,Y,_), S=(_,room(X,_,V,_)), not Y=V .
g_start(vertic,R,[S|_],S) :- 
     R=room(X,_,Y,_), S=(_,room(U,_,Y,_)), not X=U .
g_start(D,R,[_|L],S) :- 
     g_start(D,R,L,S) .

/* g_list(D,S,L,L1,LL): LL is the sublist of L containing           */
/* rectanges,that can follow rectangle S in direction D in a g_line */

g_list(_,_,[],L,L) .
g_list(D,S,[S1|L],L1,LL) :- 
     S=(_,room(X,_,Y,_)), S1=(_,room(U,_,V,_)), 
       if_dir(D,X,U,Y,V,W,Z), add_if_equal(W,Z,S1,L1,L2), 
       g_list(D,S,L,L2,LL) .

if_dir(horiz,_,_,W,Z,W,Z) .
if_dir(vertic,W,Z,_,_,W,Z) .

add_if_equal(X,X,S,L,[S|L]) :- 
     ! .
add_if_equal(_,_,_,L,L) .

/* g_next(D,R,S,L,F): F is a rectangle on list L     */
/* that can follow S forming a g_line inside rect. R */

g_next(horiz,R,S,_,S) :- 
     R=room(_,X,_,_), S=(_,room(_,X,_,_)) .
g_next(horiz,R,S1,L,F) :- 
     S1=(_,room(_,X,_,_)), member2(S2,L), S2=(_,room(X,_,_,_)), 
       g_next(horiz,R,S2,L,F) .
g_next(vertic,R,S,_,S) :- 
     R=room(_,_,_,Y), S=(_,room(_,_,_,Y)) .
g_next(vertic,R,S1,L,F) :- 
     S1=(_,room(_,_,_,Y)), member2(S2,L), S2=(_,room(_,_,Y,_)), 
       g_next(vertic,R,S2,L,F) .

/* member2(U,L): U is a member of list L */

member2(U,[U|_]) .
member2(U,[_|L]) :- 
     member2(U,L) .

/* ident_disorder(S,R): lexicographic disorder of rooms of the    */
/* same function in (partial)solution S,with room request list RL */

ident_disorder([U,V|_],RL) :- 
     disorder(U,V,RL) .
ident_disorder([U,_|S],RL) :- 
     ident_disorder([U|S],RL) .
ident_disorder([_,V|S],RL) :- 
     ident_disorder([V|S],RL) .

disorder((name(N,K1),R1),(name(N,K2),R2),RL) :- 
     find((name(N,K1),MIN1,MAX1),RL), 
       find((name(N,K2),MIN2,MAX2),RL), area(R1,A1), area(R2,A2), 
       MIN2=<A1, A1=<MAX2, MIN1=<A2, A2=<MAX1, 
       R1=room(X0,X1,Y0,Y1), R2=room(U0,U1,V0,V1), 
       wrong_order(K1,[X0,X1,Y0,Y1],K2,[U0,U1,V0,V1]) .

wrong_order(K1,L1,K2,L2) :- 
     K1<K2, non_lexic(L1,L2) .
wrong_order(K1,L1,K2,L2) :- 
     K2<K1, non_lexic(L2,L1) .

non_lexic([U|_],[V|_]) :- 
     U>V .
non_lexic([U|L1],[V|L2]) :- 
     U=V, non_lexic(L1,L2) .

minarea(6) .

maxarea(10) .

/* floor_length(FL) FL: length of horizontal wall */

minwall(2) .

increment(1) .

shape_const(5,2) .

door_size(2) .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
