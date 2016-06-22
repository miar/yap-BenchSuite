%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      mode_common.pl
%% Author(s): 
%% Program:   Common settings/predicates for all Prologs
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% initialize output streams
:- set_value('$last_output_stream',0).
:- set_value('$last_thread_id',0).
:- current_output(Stream), assert('$output_stream'(default_stdout,Stream)).
%% support for launching threads in different points of the graphs
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

run_query(misc(table_statistics_all_tables)) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** MISC ***\n']),
   table_statistics(_),
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
   tabling_statistics(total_memory,[BytesInUse1,_]),     
   BytesInUse = BytesInUse1,                             
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
   NT is N * T,
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

'$query_output_stream'(Stream,[put(39)|T]) :- !,
   put_code(Stream,39), 
   '$query_output_stream'(Stream,T).

'$query_output_stream'(Stream,[H|T]) :-
   write(Stream,H),
   '$query_output_stream'(Stream,T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'$time_query_threads'(T) :-
   get_value('$last_output_stream', Last),
   Last1 is Last + 1,
   Next is Last + T,
   set_value('$last_output_stream', Next),
   '$thread_create'(Last1, Next, TidList, time_query),
   '$thread_join'(TidList),
   fail.

'$time_query'(TimeType,N,Query) :-
   '$output_stream'(default_stdout,Stream),
   '$query_output_stream'(Stream,['\n*** TIME ***\n']),
   '$time_query_loop'(TimeType,N,TimeSum,TimeList,Query),
   round_time(Time,TimeSum,N),
   '$time_query_output'(Stream,TimeType,N,Time,TimeList),
   '$query_output_stream'(Stream,['*** END TIME ***\n']).

'$time_query_loop'(_,0,0,[],_) :- !.
'$time_query_loop'(TimeType,N,TimeSum,[Time|TimeList],Query) :-
   (abolish_all_tables, ! ; true),
   time_compatible(TimeType, TimeType1),
   statistics(TimeType1,[InitTime,_]),
   (Query ; true),
   statistics(TimeType1,[EndTime,_]),
   Time1 is EndTime - InitTime,
   adjust_to_ms(Time1,Time),
   N1 is N - 1,
   '$time_query_loop'(TimeType,N1,TimeSum1,TimeList,Query),
   TimeSum is Time + TimeSum1.

'$time_query_output'(Stream,TimeType,1,TimeAvg,_) :-  !,
   '$query_output_stream'(Stream,[TimeType,' is ', TimeAvg, ' milliseconds\n']).
'$time_query_output'(Stream,TimeType,N,TimeAvg,TimeList) :- 
   '$query_output_stream'(Stream,[TimeType,' average ', N, ' runs is ', TimeAvg, ' milliseconds ( ']),
   '$time_query_output_timelist'(Stream,TimeList),
   '$query_output_stream'(Stream,[' )\n']).

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
   get_value(default_stdout,Def_stdout),
   '$open_stream'(Def_stdout,Next),
   '$results_query'(QueryList),
   '$close_stream'(Def_stdout).

'$results_query_threads'(T, QueryList) :-
   get_value('$last_output_stream', Last),
   Last1 is Last + 1,
   Next is Last + T,
   set_value('$last_output_stream', Next),
   '$thread_create'(Last1, Next, TidList, QueryList),
   '$thread_join'(TidList).

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
'$results_query'([solutions|QueryList]) :- !,
   query_output(['\n*** SOLUTIONS ***\n']),
   (debug_query ; true),
   query_output(['*** END SOLUTIONS ***\n']),
   '$results_query'(QueryList).
'$results_query'([tables|QueryList]) :- !,
   query_output(['\n*** TABLES ***\n']),
   thread_self(Tid),
   '$output_stream'(Tid,Stream), !,
   show_all_tables(Stream),
   query_output(['*** END TABLES ***\n']),
   '$results_query'(QueryList).
'$results_query'([tries|QueryList]) :-
   query_output(['\n*** TRIES ***\n']),
   show_all_tries, 
   query_output(['*** END TRIES ***\n']),
   '$results_query'(QueryList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'$thread_create'(TRid, TRid, [Tid|[]], time_query):- !,
	thread_create(time_query,Tid).

'$thread_create'(TRid, LastTRid, [Tid|TidList], time_query):- !,
	thread_create(time_query,Tid),
         TRid1 is TRid + 1,
         '$thread_create'(TRid1, LastTRid, TidList, time_query).

'$thread_create'(TSid, TSid, [Tid|[]], QueryList):- !,
	thread_create(('$open_stream'(Tid, TSid), 
   	               '$results_query'(QueryList),
                       '$close_stream'(Tid)), Tid).

'$thread_create'(TSid, Next, [Tid|TidList], QueryList):- 
	thread_create(('$open_stream'(Tid, TSid), 
   	               '$results_query'(QueryList),
                       '$close_stream'(Tid)), Tid), 
         TSid1 is TSid + 1,
         '$thread_create'(TSid1, Next, TidList, QueryList).

'$thread_join'([]).
'$thread_join'([TRid|TRidList]):-
	'$thread_join'(TRidList),
	thread_join(TRid,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
