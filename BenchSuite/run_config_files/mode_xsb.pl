%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      mode_xsb.pl
%% Author(s): 
%% Program:   Specific settings/predicates for XSB mode
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     XSB import preds                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- import conget/2, conset/2 from machine.
:- import append/3 from basics.
:- import concat_atom/2 from string.
:- import term_to_atom/3 from string.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Compatibility preds                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set_value(X,Y) :- conset(X,Y).
get_value(X,Y) :- conget(X,Y).
atomic_list_concat(X,Y) :- concat_atom(X,Y).
round_time(Time, TimeSum, N ):- Time is floor((TimeSum / N)). % xsb mode
adjust_to_ms(Time,NTime):- NTime is floor((Time * 1000)).
%in xsb statitiscs are private to the calling thread - manual nr 1 pages 194 - 198
tabling_statistics :- statistics.
tabling_statistics(total_memory, [B,_]) :- statistics(tablespace,[B,_]). 
show_global_trie.
time_compatible(walltime,walltime).
time_compatible(cputime,runtime).
:- set_value(default_stdout,0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     XSB tabling preds                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- dynamic current_table_has_calls/0.
:- dynamic current_subgoal_has_answers/0.

show_all_tables(Stream):- usermod:tabled_predicate(Pred), show_table(Pred, Stream), fail.
show_all_tables(_).

show_table(Pred, Stream):-
   write_pred(Pred, Stream),                
   get_calls_for_table(Pred,Call), 
   new_call,    
   Call=..CallList,
   get_list_of_vars(CallList,Vars),   
   remove_var_duplicates(Vars,[],Single_Vars),
   (
      show_call(Call, Single_Vars, Stream), fail   
   ;
      show_answers(Call, Single_Vars, Stream)
   ).
show_table(_,_):-
   usermod:current_table_has_calls, !,
   retract(current_table_has_calls).
show_table(_, Stream):-
   '$query_output_stream'(Stream, ['  EMPTY\n']).

new_call:-
   usermod:current_table_has_calls, !.
new_call:-
   assert(current_table_has_calls).

get_list_of_vars([],[]):- !.
get_list_of_vars([Var|TailIn],[Var|TailOut]):- 
   var(Var), !,
   get_list_of_vars(TailIn,TailOut).
get_list_of_vars([Atom|TailIn],ListOut):- 
   atomic(Atom), !,
   get_list_of_vars(TailIn,ListOut).
get_list_of_vars([Compound|TailIn],ListOut):- 
   Compound=..CompoundList,
   get_list_of_vars(CompoundList,CoumpoundListOut),
   get_list_of_vars(TailIn,TailOut),
   append(CoumpoundListOut,TailOut,ListOut).

remove_var_duplicates([],_,[]):- !.
remove_var_duplicates([Var|TailIn],ListVisited,ListOut):- 
   var_member(Var,ListVisited), !, 
   remove_var_duplicates(TailIn,ListVisited,ListOut).
remove_var_duplicates([Var|TailIn],ListVisited,[Var|TailOut]):- 
   remove_var_duplicates(TailIn,[Var|ListVisited],TailOut).

var_member(_,[]):- !, fail.
var_member(V,[H|_]):- V == H, !.
var_member(V,[_|T]):- var_member(V,T).

ground_vars(_,[],_):- !.
ground_vars(Text,[Var|Tail],Index):-
   concat_atom([Text,Index],Var),
   NextIndex is Index + 1,
   ground_vars(Text,Tail,NextIndex).

show_call(Call, VarsList, Stream):- 
   ground_vars('VAR',VarsList,0),
   write_call(Call, Stream).                        

show_answers(Call, VarsList, Stream):-
   get_returns_for_call(Call,Call),
   (VarsList = [] ->  
      '$query_output_stream'(Stream, ['    TRUE\n']), !
   ; 
      new_answer,
      get_list_of_vars(VarsList,Vars), 
      remove_var_duplicates(Vars,[],Single_Vars),
      ground_vars('ANSVAR',Single_Vars,0),
      write_answer(VarsList, 0, Stream)
   ).
show_answers(_,_,_):-
   usermod:current_subgoal_has_answers, !,
   retract(current_subgoal_has_answers).
show_answers(_,_, Stream):-
   '$query_output_stream'(Stream, ['    NO\n']).

new_answer:-
   usermod:current_subgoal_has_answers, !.
new_answer:-
   assert(current_subgoal_has_answers).

write_pred(Name/Arity, Stream):-
   '$query_output_stream'(Stream, ['Table structure for predicate ', put(39), Name, '/', Arity, put(39), '\n']).

write_call(Call, Stream):-
   '$query_output_stream'(Stream, ['  ?- ', Call, '.\n']).

write_answer([],_, Stream):- !, '$query_output_stream'(Stream, ['\n']).
write_answer([Ans|Tail], Index, Stream):-
   '$query_output_stream'(Stream, ['    VAR', Index, ': ', Ans]),
   NextIndex is Index + 1,
   write_answer(Tail, NextIndex, Stream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     mode_common.pl                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:- include('mode_file.pl').
:- ['mode_common.pl'].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%