##################################################################
##
## File:      run_tests_dir.sh
## Author(s): Miguel Areias and Ricardo Rocha
## Program:   Script for running tests in a directory
##
##################################################################

#!/bin/sh

PROLOG_BIN=$1
MODE_FILE=$2
QUERY_FILE=$3
OUTPUT_DIR=$4
TESTS_DIR=$5
REPORT_FILENAME="${OUTPUT_DIR}"/run_report.info

show_run_info () {
   echo -n -e "$1"
   echo -n -e "$1" >> "${REPORT_FILENAME}"
}

check_output () {
   failed=0
   file_default=${OUTPUT_DIR}/${1}
   file_ok=${RESULTS_OK_DIR}/${1}
   ### EXECUTION ###
   error_execution=0
   test -e ${file_default}.output -a ! -e ${file_default}.query_error || error_execution=1
   ### DEBUG ###
   error_debug=0
   if test -e ${file_default}.debug; then
      error_debug=1
   fi
   ### FAILED ###
   if test `expr ${error_execution} + ${error_debug}` -eq 0; then
      rm -f ${file_default}.output ${file_default}.stderr 2> /dev/null
   else
      failed=1
      show_run_info "failed!\n   main:"
      if test ${error_execution} -eq 1; then
         show_run_info "  [ execution error ]"
      else
         rm -f ${file_default}.output ${file_default}.stderr 2> /dev/null
      fi
      if test ${error_debug} -eq 1; then
         show_run_info "$(cat ${file_default}.debug)"
      fi
      if test ${error_execution} -eq 1; then
         return 1
      fi
   fi
   ### STREAMS ###
   if test -e ${file_default}.streams; then
      read runs threads streams < ${file_default}.streams 2> /dev/null
      rm -f ${file_default}.streams 2> /dev/null
      for ((s=1; s<=${streams}; s++)); do
         file_stream=${file_default}_output_stream_${s}
         mv ${OUTPUT_DIR}/output_stream_${s} ${file_stream}
	 python ${OUTPUT_FILTER} ${file_stream} 2> /dev/null < ${file_stream}
	 rm -f ${file_stream} 2> /dev/null
         if test ${threads} -eq 0; then
            r=${s}
            t=0
         else
            if test ${runs} -eq 1; then
	       r=0
               t=${s}
            else
               r=`expr \( ${s} - 1 \) / ${threads} + 1`
               t=`expr \( ${s} - 1 \) % ${threads} + 1`
            fi
         fi
    	 check_stream_output ${file_stream} ${file_ok} ${r} ${t} ${failed} || failed=1
      done
   fi
   ### TIME/OK ###
   if test ${failed} -eq 0; then
      if test -e ${file_default}.time; then
         show_run_info "$(cat ${file_default}.time)"
      else
         show_run_info "ok!"
      fi
      return 0
   fi
   return 1
}

check_stream_output () {
   file_stream=${1}
   file_ok=${2}
   run=${3}
   thread=${4}
   failed=${5}
   ### EXECUTION ###
   error_execution=0
   test -e ${file_stream}.output -a ! -e ${file_stream}.query_error || error_execution=1
   ### SOLUTIONS ###
   error_solutions=0
   error_solutions_xsb=0
   if test -e ${file_stream}.solutions; then
      diff ${file_stream}.solutions ${file_ok}.solutions > ${file_stream}.diff_solutions 2>> ${file_stream}.stderr || error_solutions=1
      if test ${error_solutions} -eq 1; then
         diff ${file_stream}.solutions ${file_ok}.solutions_xsb > /dev/null 2>> /dev/null || error_solutions_xsb=1
      fi
   fi
   ### TABLES ###
   error_tables=0
   error_tables_xsb=0
   if test -e ${file_stream}.tables; then
      diff ${file_stream}.tables ${file_ok}.tables > ${file_stream}.diff_tables 2>> ${file_stream}.stderr || error_tables=1
      if test ${error_tables} -eq 1; then
         diff ${file_stream}.tables ${file_ok}.tables_xsb > /dev/null 2>> /dev/null || error_tables_xsb=1
      fi
   fi
   ### TRIES ###
   error_tries=0
   if test -e ${file_stream}.tries; then
      diff ${file_stream}.tries ${file_ok}.tries > ${file_stream}.diff_tries 2>> ${file_stream}.stderr || error_tries=1
   fi
   ### FAILED ###
   if test `expr ${error_execution} + ${error_solutions} + ${error_tables} + ${error_tries}` -eq 0; then
      rm -f ${file_stream}.output ${file_stream}.stderr 2> /dev/null
      if test -e ${file_stream}.solutions; then
         rm -f ${file_stream}.solutions ${file_stream}.diff_solutions 2> /dev/null
      fi
      if test -e ${file_stream}.tables; then
         rm -f ${file_stream}.tables ${file_stream}.diff_tables 2> /dev/null
      fi
      if test -e ${file_stream}.tries; then
         rm -f ${file_stream}.tries ${file_stream}.diff_tries 2> /dev/null
      fi
      return 0
   else
      if test ${failed} -eq 0; then
         show_run_info "failed!"
      fi
      show_run_info "\n   "
      if test ! ${run} -eq 0; then
         show_run_info "run ${run}"
         if test ! ${thread} -eq 0; then
            show_run_info " thread ${thread}"
         fi
      else
         show_run_info "thread ${n_thread}"
      fi
      show_run_info ":"
      if test ${error_execution} -eq 1; then
         show_run_info "  [ execution error ]"
      else
         rm -f ${file_stream}.output ${file_stream}.stderr 2> /dev/null
      fi
      if test ${error_solutions} -eq 1; then
         if test ${error_solutions_xsb} -eq 1; then
            show_run_info "  [ solutions output ]"
         else
            show_run_info "  [ solutions output (XSB compatible) ]"
         fi
      else
         rm -f ${file_stream}.solutions ${file_stream}.diff_solutions 2> /dev/null
      fi
      if test ${error_tables} -eq 1; then
         if test ${error_tables_xsb} -eq 1; then
            show_run_info "  [ tables output ]"
         else
            show_run_info "   [ tables output (XSB compatible) ]"
         fi
      else
         rm -f ${file_stream}.tables ${file_stream}.diff_tables 2> /dev/null
      fi
      if test ${error_tries} -eq 1; then
         show_run_info "  [ tries output ]"
      else
         rm -f ${file_stream}.tries ${file_stream}.diff_tries 2> /dev/null
      fi
      return 1
   fi
}

CURRENT_DIR=${PWD}
OUTPUT_FILTER=${CURRENT_DIR}/run_config_files/run_output_filter.py
RUN_CONFIG_FILES_DIR=${CURRENT_DIR}/run_config_files
cd ${TESTS_DIR}
TEST_FILES=$(ls test_*.pl 2> /dev/null)
DATA_FILES=$(ls data_*.pl 2> /dev/null)
RESULTS_OK_DIR=results_ok
TESTS_FAILED=0

for test_file in ${TEST_FILES}; do
   if test -z "${DATA_FILES}"; then
      file=${test_file%.pl}
      show_run_info "test '${file}': "
#      ${PROLOG_BIN} <<xxxQUERY_GOALSxxx 2> ${OUTPUT_DIR}/${file}.stderr
      ${PROLOG_BIN} <<xxxQUERY_GOALSxxx 2> ${OUTPUT_DIR}/${file}.stderr | python ${OUTPUT_FILTER} ${OUTPUT_DIR}/${file} 2> /dev/null
         ['${QUERY_FILE}'].
         ['${test_file}'].
         cd('${RUN_CONFIG_FILES_DIR}').
         ['${MODE_FILE}'].
         cd('${OUTPUT_DIR}').
         run_query.
         halt.
xxxQUERY_GOALSxxx
      check_output ${file} || TESTS_FAILED=`expr ${TESTS_FAILED} + 1`
      show_run_info "\n"
   else
      for data_file in ${DATA_FILES}; do
         file=${test_file%.pl}_${data_file%.pl}
         show_run_info "test '${file}': "
         ${PROLOG_BIN} <<xxxQUERY_GOALSxxx 2> ${OUTPUT_DIR}/${file}.stderr | python ${OUTPUT_FILTER} ${OUTPUT_DIR}/${file} 2> /dev/null
            ['${QUERY_FILE}']. 
            ['${test_file}']. 
            ['${data_file}']. 
            cd('${RUN_CONFIG_FILES_DIR}').
            ['${MODE_FILE}']. 
            cd('${OUTPUT_DIR}').
            run_query.
            halt.
xxxQUERY_GOALSxxx
         check_output ${file} || TESTS_FAILED=`expr ${TESTS_FAILED} + 1`
         show_run_info "\n"
      done
   fi
done

rm -f *.xwam
rm -f mapfile*
cd ${CURRENT_DIR}
exit ${TESTS_FAILED}