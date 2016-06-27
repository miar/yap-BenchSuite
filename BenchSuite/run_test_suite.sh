##################################################################
##
## File:      run_test_suite.sh
## Author(s): Miguel Areias and Ricardo Rocha
## Program:   Script for running the test suite
##
##################################################################

#!/bin/sh

DEFAULT_DIR_LIST="tests_tabling"
DEFAULT_OUTPUT_DIR="run_output_files"
DEFAULT_MODE_FILE="run_config_files/mode_yap.pl"
DEFAULT_QUERY_PREDEF="debug_tabling"
DEFAULT_N_RUNS=1
DEFAULT_N_THREADS=0
DEFAULT_ARGUMENTS=""

while test 1=1; do
   case "$1" in
      -d*)  shift
	    DIR_LIST=$1
	    shift;;
      -o*)  shift
	    OUTPUT_DIR=$1
	    shift;;
      -m*)  shift
	    MODE_FILE=$1
	    shift;;
      -q*)  shift
	    QUERY_FILE=$1
	    shift;;
      -p*)  shift
	    QUERY_PREDEF=$1
	    shift;;
      -r*)  shift
	    N_RUNS=$1
	    shift;;
      -t*)  shift
	    N_THREADS=$1
	    shift;;
      -a*)  shift
	    ARGUMENTS=$1
	    shift;;
        *)  break;;
   esac
done

if test -z "$1" -o $# -gt 1; then
   echo
   echo "Usage: ./run_test_suite.sh [-d \"tests_dir_list\"] [-o out_dir] [-m mode_file] [-q query_file] [-p query_predef] [-r runs] [-t threads] [-a \"args\"] prolog_bin"
   echo "where: tests_dir_list -- quoted, space-separated list of directory tests to run (default: ${DEFAULT_DIR_LIST})"
   echo "       out_dir        -- output directory (default: ${DEFAULT_OUTPUT_DIR})"
   echo "       mode_file      -- Prolog file defining general settings/predicates for all tests (default: ${DEFAULT_MODE_FILE})"
   echo "       query_file     -- Prolog file with a user-defined run query predicate, overrides [-t query_type] [-r runs] [-t threads] options"
   echo "       query_predef   -- pre-defined run query predicate (default: ${DEFAULT_QUERY_PREDEF} all: cputime|walltime|debug_prolog|debug_tabling|debug_tries_module)"
   echo "       runs           -- number of runs for the run query predicate (default: ${DEFAULT_N_RUNS})"
   echo "       threads        -- number of threads for the run query predicate (default: ${DEFAULT_N_THREADS}) (not available on BProlog)"
   echo "       args           -- quoted, command line arguments to be passed to the Prolog executable (if BProlog then use -l)"
   echo "       prolog_bin     -- Prolog executable"
   echo
   exit 1
fi

PROLOG_BIN=$1
if test -z "${DIR_LIST}"; then
    DIR_LIST=${DEFAULT_DIR_LIST}
fi
if test -z "${OUTPUT_DIR}"; then
   OUTPUT_DIR=${DEFAULT_OUTPUT_DIR}
fi
if test -z "${MODE_FILE}"; then
   MODE_FILE=${DEFAULT_MODE_FILE}
fi
if test -z "${QUERY_PREDEF}"; then
   QUERY_PREDEF=${DEFAULT_QUERY_PREDEF}
fi
if test -z "${N_RUNS}"; then
   N_RUNS=${DEFAULT_N_RUNS}
fi
if test -z "${N_THREADS}"; then
   N_THREADS=${DEFAULT_N_THREADS}
fi
if test -z "${ARGUMENTS}"; then
    ARGUMENTS=${DEFAULT_ARGUMENTS}
fi

if test -x "${PWD}/${PROLOG_BIN}"; then
   PROLOG_BIN="${PWD}/${PROLOG_BIN}"
else
   if test ! -x "${PROLOG_BIN}"; then
      echo
      echo "Can't execute '${PROLOG_BIN}'"
      echo "Aborting ..."
      echo
      exit 1
   fi
fi

if test -d "${PWD}/${OUTPUT_DIR}"; then
   OUTPUT_DIR="${PWD}/${OUTPUT_DIR}"
else
   if test ! -d "${OUTPUT_DIR}"; then
      echo
      echo "Can't find directory '${OUTPUT_DIR}'"
      echo "Aborting ..."
      echo
      exit 1
   fi
fi

if test -f "${PWD}/${MODE_FILE}"; then
   MODE_FILE="${PWD}/${MODE_FILE}"
else
   if test ! -f "${MODE_FILE}"; then
      echo
      echo "Can't find file '${MODE_FILE}'"
      echo "Aborting ..."
      echo
      exit 1
   fi
fi

if test -z "${QUERY_FILE}"; then
   case "${QUERY_PREDEF}" in
      cputime) ;;
      walltime) ;;
      debug_prolog) ;;
      debug_tabling) ;;
      debug_tries_module) ;;
      *) echo
         echo "Unavailable pre-defined query type '${QUERY_PREDEF}'"
         echo "Aborting ..."
         echo
         exit 1;;
   esac
   if ! [[ "${N_RUNS}" =~ ^[0-9]+$ && "${N_RUNS}" != 0 ]]; then
      echo
      echo "Not a valid number of runs '${N_RUNS}'"
      echo "Aborting ..."
      echo
      exit 1
   fi
   if ! [[ "${N_THREADS}" =~ ^[0-9]+$ ]] ; then
      echo
      echo "Not a valid number of threads '${N_THREADS}'"
      echo "Aborting ..."
      echo
      exit 1
   fi
   QUERY_FILE="${OUTPUT_DIR}"/query_"${QUERY_PREDEF}"_"${N_RUNS}"_runs_"${N_THREADS}"_threads.pl
   run_config_files/run_query.sh "${QUERY_PREDEF}" "${N_RUNS}" "${N_THREADS}" > "${QUERY_FILE}"
fi

if test -f "${PWD}/${QUERY_FILE}"; then
   QUERY_FILE="${PWD}/${QUERY_FILE}"
else
   if test ! -f "${QUERY_FILE}"; then
      echo
      echo "Can't find file '${QUERY_FILE}'"
      echo "Aborting ..."
      echo
      exit 1
   fi
fi

show_run_info() {
   echo "***********************"
   echo "***     run info    ***"
   echo "***********************"
   echo "PROLOG_BIN: ${PROLOG_BIN} ${ARGUMENTS}"
   echo "MODE_FILE:  ${MODE_FILE}"
   echo "QUERY_FILE: ${QUERY_FILE}"
   echo "OUTPUT_DIR: ${OUTPUT_DIR}"
}

show_summary() {
   echo "**********************"
   echo "***     summary    ***"
   echo "**********************"
   echo "PROLOG_BIN:   ${PROLOG_BIN} ${ARGUMENTS}"
   echo "MODE_FILE:    ${MODE_FILE}"
   echo "QUERY_FILE:   ${QUERY_FILE}"
   echo "OUTPUT_DIR:   ${OUTPUT_DIR}"
   echo "START_TIME:   ${START_TIME}"
   echo "END_TIME:     ${END_TIME}"
   echo "TESTS_FAILED: ${TESTS_FAILED}"
}

show_tests_dir_info() {
   LINE="****************"
   for ((i = 0; i < ${#1}; i++)); do
       LINE="${LINE}"*
   done
   echo "${LINE}"
   echo "***     $1     ***"
   echo "${LINE}"
}

run_tests_dir_list() {
   for dir in ${1}; do
       subdir_list=$(ls -d ${dir}/tests_* 2> /dev/null)
       if test -z "${subdir_list}"; then
	   show_tests_dir_info "${PWD}/${dir}" >> "${REPORT_FILENAME}"
	   show_tests_dir_info "${PWD}/${dir}"
	   run_config_files/run_tests_dir.sh "${PROLOG_BIN} ${ARGUMENTS}" "${MODE_FILE}" "${QUERY_FILE}" "${OUTPUT_DIR}" "${PWD}/${dir}"
	   TESTS_FAILED=`expr ${TESTS_FAILED} + $?`
       else
	   for subdir in ${subdir_list}; do
               if test -d "${subdir}"; then
		   run_tests_dir_list ${subdir}
               fi
	   done
       fi
   done
}

OUTPUT_DIR="${OUTPUT_DIR}"/run_$(date +%m-%d-%Y-%T)
mkdir "${OUTPUT_DIR}"
REPORT_FILENAME="${OUTPUT_DIR}"/run_report.info
show_run_info > "${REPORT_FILENAME}"
show_run_info
TESTS_FAILED=0
START_TIME=$(date "+%m-%d-%Y %T")
run_tests_dir_list "${DIR_LIST}"
END_TIME=$(date "+%m-%d-%Y %T")
show_summary >> "${REPORT_FILENAME}"
show_summary

exit ${TESTS_FAILED}



