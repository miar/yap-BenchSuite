##################################################################
##
## File:      run_output_filter.py
## Author(s): Miguel Areias and Ricardo Rocha
## Program:   Script for sorting the output
##
##################################################################

import sys
import os
import operator

########## parse line ##########

def parse_line_tables():
    if (line[0:5] == "Table"):
        tables.append((line,[]))
    elif (line[2] == "?" or line[2:7] == "EMPTY"):
        tables[len(tables) - 1][1].append((line,[]))
    elif (line[4:8] == "TRUE" or line[4:6] == "NO" or line[4:7] == "VAR"):
        args = tables[len(tables) - 1][1]
        args[len(args) - 1][1].append(line)

def parse_line_tries():
    if (line[0:19] == "Trie structure for "):
        tries.append((line,[]))
    else:
        tries[len(tries) - 1][1].append((line,[]))

########## main ##########

try:
    fout = open(sys.argv[1] + '.output', 'w')
    fout.close()
    fout = open(sys.argv[1] + '.query_error', 'w')
    fout.close()
    query_error = 1
    debug_error = 0
#    print "oollla"

    while (1):
        line = raw_input()
        while (line[0:3] != "***"):
            line = raw_input()
        ### TIME ###
        if (line == "*** TIME ***"):
            query_error = 1
            fout = open(sys.argv[1] + '.time', 'w')
            line = raw_input()        
            while (line != "*** END TIME ***"):
                fout.write(line + '\n')
                line = raw_input()
            fout.close()
            query_error = 0
        ### SOLUTIONS ###
        elif (line == "*** SOLUTIONS ***"):
            query_error = 1
            solutions = []
            fout = open(sys.argv[1] + '.solutions', 'w')
            line = raw_input()
            while (line != "*** END SOLUTIONS ***"):
                solutions.append(line)
                line = raw_input()
            solutions_sorted = sorted(solutions)
            for solution in solutions_sorted:
                fout.write(solution + '\n')
            fout.close()
            solutions = []
            query_error = 0
        ### TABLES ###
        elif (line == "*** TABLES ***"):
            query_error = 1
            tables = []
            fout = open(sys.argv[1] + '.tables', 'w')
            line = raw_input()
            while (line != "*** END TABLES ***"):
                parse_line_tables()
                line = raw_input()
            predicates_sorted = sorted(tables, key=operator.itemgetter(0))
            for predicate in predicates_sorted:
                fout.write(predicate[0] + '\n')
                subgoals_sorted = sorted(predicate[1], key=operator.itemgetter(0))
                for subgoal in subgoals_sorted:
                    fout.write(subgoal[0] + '\n')
                    answers_sorted = sorted(subgoal[1])
                    for answer in answers_sorted:
                        fout.write(answer + '\n')
            fout.close()
            tables = []
            query_error = 0
        ### TRIES ###
        elif (line == "*** TRIES ***"):
            query_error = 1
            tries = []
            fout = open(sys.argv[1] + '.tries', 'w')
            line = raw_input()
            while (line != "*** END TRIES ***"):
                parse_line_tries()
                line = raw_input()
            tries_sorted = sorted(tries, key=operator.itemgetter(0))
            for trie in tries_sorted:
                fout.write(trie[0] + '\n')
                entries_sorted = sorted(trie[1])
                for entry in entries_sorted:
                    fout.write('  ENTRY: ' + entry[0] + '\n')
            fout.close()
            tries = []
            query_error = 0
        ### MISC ###
        elif (line == "*** MISC ***"):
            query_error = 1
            fout = open(sys.argv[1] + '.misc', 'a')
            line = raw_input()        
            while (line != "*** END MISC ***"):
                fout.write(line + '\n')
                line = raw_input()
            fout.close()
            query_error = 0
        ### STREAMS ###
        elif (line == "*** STREAMS ***"):
            query_error = 1
            fout = open(sys.argv[1] + '.streams', 'w')
            line = raw_input()        
            while (line != "*** END STREAMS ***"):
                fout.write(line + '\n')
                line = raw_input()
            fout.close()
            query_error = 0
        ### DEBUG ###
        elif (line == "*** DEBUG ***"):
            debug_error = 1
            debug_line = raw_input()
            line = raw_input()            
            if (line != "*** END DEBUG ***"):
                fout = open(sys.argv[1] + '.debug', 'a')
                fout.write(debug_line)
                fout.close()
            debug_error = 0
except EOFError:
    if (debug_error == 1):
        fout = open(sys.argv[1] + '.debug', 'a')
        fout.write(debug_line)
        fout.close()
    if (query_error == 0):
        os.remove(sys.argv[1] + '.query_error')
    sys.exit()
