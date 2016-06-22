%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      mode_yap.pl
%% Author(s): Ricardo Rocha
%% Program:   General settings/predicates for Yap/YapTab mode
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% define 'fail' as the action to be taken when calling an undefined 
%% procedure such as abolish_all_tables/0 when tabling is not enabled
:- unknown(_,fail).

%% initialize output streams 
:- current_output(Stream), assert('$output_stream'(default_stdout,Stream)).
:- set_value('$last_output_stream',0).
:- dynamic '$dynamic_thread_launcher'/1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query(misc(prolog_statistics)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** MISC ***\n']),
   statistics,
   '$query_output_stream'(Stream,['*** END MISC ***\n']),
   fail.

run_query(misc(tabling_statistics)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** MISC ***\n']),
   tabling_statistics,
   '$query_output_stream'(Stream,['*** END MISC ***\n']),
   fail.

run_query(misc(global_trie)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** MISC ***\n']),
   show_global_trie,
   '$query_output_stream'(Stream,['*** END MISC ***\n']),
   fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query(set_info(tabling_total_memory)) :-
   tabling_statistics(total_memory,[BytesInUse,_]),
   set_value('$tabling_total_memory',BytesInUse),
   fail.

run_query(debug(tabling_total_memory)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** DEBUG ***\n  [ tabling total memory ]\n']),
   get_value('$tabling_total_memory',BytesInUse),
   tabling_statistics(total_memory,[BytesInUse,_]),
   '$query_output_stream'(Stream,['*** END DEBUG ***\n']),
   fail.

run_query(debug(number_of_threads(N))) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** DEBUG ***\n  [ number of threads ]\n']),
   statistics(threads,N),
   '$query_output_stream'(Stream,['*** END DEBUG ***\n']),
   fail.

run_query(debug(abolish_tables)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** DEBUG ***\n  [ abolish tables ]\n']),
   abolish_all_tables,
   '$query_output_stream'(Stream,['*** END DEBUG ***\n']),
   fail.

run_query(debug(abolish_tries)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** DEBUG ***\n  [ abolish tries ]\n']),
   abolish_all_tries,
   '$query_output_stream'(Stream,['*** END DEBUG ***\n']),
   fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query(cputime(runs(N),threads(0))) :- !,
   '$time_query'(cputime,N,time_query),
   fail.

run_query(cputime(runs(N),threads(T))) :-
    ('$dynamic_thread_launcher'(T), !; true),   
   '$time_query'(cputime,N,'$time_query_threads'(T)),
   fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query(walltime(runs(N),threads(0))) :- !,
   '$time_query'(walltime,N,time_query),
   fail.

run_query(walltime(runs(N),threads(T))) :-
   ('$dynamic_thread_launcher'(T), !; true),
   '$time_query'(walltime,N,'$time_query_threads'(T)),
   fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_query(results(QueryList,runs(N),threads(0))) :- !,
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** STREAMS ***\n', N, ' ', 0, ' ', N, '\n']),
   '$results_query_loop'(N,'$results_query_main'(QueryList)),
   '$query_output_stream'(Stream,['*** END STREAMS ***\n']),
   fail.

run_query(results(QueryList,runs(N),threads(T))) :-
   ('$dynamic_thread_launcher'(T), !; true),
   NT is N * (T + 1),
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** STREAMS ***\n', N, ' ', T, ' ', NT, '\n']),
   '$results_query_loop'(N,'$results_query_threads'(T,QueryList)),
   '$query_output_stream'(Stream,['*** END STREAMS ***\n']),
   fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

query_output(Out) :- 
   thread_self(Tid),
   '$output_stream'(Tid,Stream), !,
   '$query_output_stream'(Stream,Out).

'$query_output_stream'(_,[]) :- !.
'$query_output_stream'(Stream,[H|T]) :-
   write(Stream,H),
   '$query_output_stream'(Stream,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'$time_query_threads'(T) :-
   forall(between(1,T,_),thread_create(time_query,_)),
%   forall(between(1,T,_),thread_create((statistics(thread_cputime_utime,X), writeln(X),(time_query;true),statistics(thread_cputime_utime,Y),writeln(Y)),_)),
   forall(between(1,T,Tid),thread_join(Tid,_)),
   fail.

'$time_query'(TimeType,N,Query) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** TIME ***\n']),
   '$time_query_loop'(TimeType,N,TimeSum,TimeList,Query),
   Time is integer(TimeSum / N),
   '$time_query_output'(Stream,TimeType,N,Time,TimeList),
   '$query_output_stream'(Stream,['*** END TIME ***\n']).

'$time_query_loop'(_,0,0,[],_) :- !.
'$time_query_loop'(TimeType,N,TimeSum,[Time|TimeList],Query) :-
   (abolish_all_tables, ! ; true),
   statistics(TimeType,[InitTime,_]),
   (Query ; true),
   statistics(TimeType,[EndTime,_]),
   Time is EndTime - InitTime,
   N1 is N - 1,
   '$time_query_loop'(TimeType,N1,TimeSum1,TimeList,Query),
   TimeSum is Time + TimeSum1.

'$time_query_output'(Stream,TimeType,1,TimeAvg,_) :-  !,
   '$query_output_stream'(Stream,[TimeType,' is ', TimeAvg, ' milliseconds\n']),
   show_cputime_by_thread(Stream). %%new

'$time_query_output'(Stream,TimeType,N,TimeAvg,TimeList) :- 
   '$query_output_stream'(Stream,[TimeType,' average ', N, ' runs is ', TimeAvg, ' milliseconds ( ']),
   '$time_query_output_timelist'(Stream,TimeList),
   '$query_output_stream'(Stream,[' )\n']), 
   show_cputime_by_thread(Stream). %% new


'$time_query_output_timelist'(Stream,[Time]) :- !,
   '$query_output_stream'(Stream,[Time]).
'$time_query_output_timelist'(Stream,[Time|TimeList]) :-
   '$query_output_stream'(Stream,[Time, ' / ']),
   '$time_query_output_timelist'(Stream,TimeList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'$results_query_main'(QueryList) :-
   get_value('$last_output_stream',Last),
   Next is Last + 1,
   set_value('$last_output_stream',Next),
   '$open_stream'(main,Next),
   '$results_query'(QueryList),
   '$close_stream'(main).

'$results_query_threads'(T,QueryList) :-
   get_value('$last_output_stream',Last),
   Next is Last + T,
   set_value('$last_output_stream',Next),
   forall(between(1,T,Tid1),
      (Sid1 is Tid1 + Last,'$open_stream'(Tid1,Sid1),thread_create('$results_query'(QueryList),_))),
   forall(between(1,T,Tid2),
      (thread_join(Tid2,_),'$close_stream'(Tid2))),
   % for the FS we print the tables only on the main thread
   '$results_query_main'(QueryList).


'$results_query_loop'(0,_) :- !.
'$results_query_loop'(N,Query) :-
   (abolish_all_tables, ! ; true),
   Query,
   N1 is N - 1,
   '$results_query_loop'(N1,Query).

'$open_stream'(Tid,Sid) :-
   atomic_list_concat(['output_stream_',Sid],FileName),
   open(FileName,'write',Stream),
   assert('$output_stream'(Tid,Stream)).

'$close_stream'(Tid) :-
   '$output_stream'(Tid,Stream),
   close(Stream),
   retract('$output_stream'(Tid,Stream)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'$results_query'([]) :- !.
'$results_query'([solutions|QueryList]) :- 
   thread_self(Tid), Tid \= main, !,
   query_output(['\n*** SOLUTIONS ***\n']),
   (debug_query ; true),
   query_output(['*** END SOLUTIONS ***\n']),
   '$results_query'(QueryList).

'$results_query'([solutions|QueryList]) :- 
   '$results_query'(QueryList).

'$results_query'([tables|QueryList]) :- !,
   thread_self(main),
   query_output(['\n*** TABLES ***\n']),
   '$output_stream'(main,Stream), !,
   show_all_tables(Stream),
   query_output(['*** END TABLES ***\n']),
   '$results_query'(QueryList).

'$results_query'([tries|QueryList]) :-
   query_output(['\n*** TRIES ***\n']),
   show_all_tries, 
   query_output(['*** END TRIES ***\n']),
   '$results_query'(QueryList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
