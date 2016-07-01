#!/bin/bash

DIR=$PWD


cd /home/miguel/Development/BenchEnviro/logtalk3/tests/prolog/predicates/findall_3
yaplgt -g "true,logtalk_load(tester),halt"  > $DIR/__temp.out
cd $DIR

#cleaning file and compare

while read -r line; do
    if [ "${#line}" -gt "10" ]; then
	if [ ["${line:0:7}" != "Logtalk"] -a ["${line:0:9}" != "Copyright"] ]; then
	    echo "${line}"
	fi
    fi
done < "__temp.out"

#rm __temp.out
