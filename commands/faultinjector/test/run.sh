#!/usr/bin/env bash

cd `dirname $0`

function usage(){
    echo USAGE: $0 testname ...
}

function do_test(){
    TEST_DIR=$1
    if [ ! -d "$TEST_DIR" ]; then
        echo ERROR: directory \'$TEST_DIR\' does not exist
        exit 1;
    fi

    ARGS_FILE=$TEST_DIR/args.sh
    . $ARGS_FILE

    FAULT_OUT=/tmp/fault_output
    FAULT_OUT_FILTERED=/tmp/fault_output_filtered
    REF_OUT=reference_output
    STATS_LINE="faultinjector stats:"

    LLVM_CONF=FAULT make clean;

    LLVM_CONF=FAULT LLVM_PASS_ARGS="$ARGS" make all

    ./faulttest $RAND_SEED > $FAULT_OUT

    awk "/$OUTPUT_FROM/,/$OUTPUT_TO/{if (!/$OUTPUT_FROM/&&!/$OUTPUT_TO/)print}" $FAULT_OUT > $FAULT_OUT_FILTERED
    awk "/$STATS_LINE/,/asdfasdfas/{if (!/$STATS_LINE/)print}" $FAULT_OUT >> $FAULT_OUT_FILTERED


    diff $TEST_DIR/$REF_OUT $FAULT_OUT_FILTERED > /dev/null
    DIFF_EXIT_CODE=$?

    if [ $DIFF_EXIT_CODE -ne 0 ]; then
        echo ERROR: diff of output with reference output:
        diff -u no-load/$REF_OUT $FAULT_OUT
        exit 1
    fi
   
}


if [ $# -eq 0 ]; then
    usage
    exit 1
fi


if [ "$1" == "all" ]; then
    TESTS=`find . -type d -mindepth 1`
    echo all: $TESTS
else
    TESTS=$*
fi

for TEST in $TESTS; do
    echo TESTING: $TEST
    do_test `basename $TEST` 
done

