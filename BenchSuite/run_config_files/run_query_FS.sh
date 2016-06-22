##################################################################
##
## File:      run_query.sh
## Author(s): Ricardo Rocha
## Program:   Pre-defined run_query predicates
##
##################################################################

#!/bin/sh

QUERY_TYPE=$1
N_RUNS=$2
N_THREADS=$3

case ${QUERY_TYPE} in
   *time)
      echo "run_query :- run_query(${QUERY_TYPE}(runs(${N_RUNS}),threads(${N_THREADS}))).";;
   debug_prolog)
      echo "run_query :- run_query(results([solutions],runs(${N_RUNS}),threads(${N_THREADS}))).";;
   debug_tabling_FS)
      echo "run_query :- run_query(set_info(tabling_total_memory))."
      echo "run_query :- run_query(results([solutions,tables],runs(${N_RUNS}),threads(${N_THREADS})))." 
      echo "run_query :- run_query(misc(tabling_statistics))."
      echo "run_query :- run_query(debug(abolish_tables))."
      echo "run_query :- run_query(debug(tabling_total_memory)).";;
   debug_tries_module)
      echo "run_query :- run_query(results([solutions,tries],runs(${N_RUNS}),threads(${N_THREADS})))."
      echo "run_query :- run_query(debug(abolish_tries)).";;
esac

##################################################################
