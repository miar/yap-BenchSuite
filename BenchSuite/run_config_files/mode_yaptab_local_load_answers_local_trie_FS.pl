%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      
%% Author(s): 
%% Program:   
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:- ['mode_yap.pl'].  %% wrong
%:- ['mode_yap_original_version_FS.pl'].
%:- ['mode_yap_original_version_FS_cputime_by_thread.pl'].
:- ['mode_yap_original_version_FS_cputime_by_thread_THESIS.pl']. % includes the abolish_all_tables on runtime

:- yap_flag(tabling_mode,[local,load_answers,local_trie]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
