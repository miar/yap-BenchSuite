%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% File:      mode_yaptab_local_load_answers_local_trie.pl
%% Author(s): Ricardo Rocha
%% Program:   Sets the tabling mode for all tabled predicates
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:- ['mode_yap.pl'].
:- ['mode_yap_original_version.pl'].

:- yap_flag(tabling_mode,[local,load_answers,local_trie]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
