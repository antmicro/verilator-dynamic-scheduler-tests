#!/usr/bin/env bash

set -e

###############
# PREPARATION #
###############

export REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEST_SUITE="$1"
TEST=$(realpath "$1")
shift

if [[ $1 =~ ^[0-9]+$ ]]; then
    echo "2nd param is number"
    REPEAT=$1
    shift
fi

function check_file() {
    if [[ ! -e "$1" ]]; then
        echo "$3 for $2 missing"
        exit 1
    fi
}

function run_test() {
    local TEST_FILE=$1
    shift
    local TEST_NAME=$(basename ${TEST_FILE%.*})
    local EXPECTED_OUT="${TEST_FILE%.*}.out"

    check_file $EXPECTED_OUT "$TEST_SUITE/$TEST_NAME" "Expected output"

    local OUT_DIR="$REPO_DIR/out/$TEST_SUITE/$TEST_NAME"
    local ACTUAL_OUT="$OUT_DIR/output"
    mkdir -p $OUT_DIR

    echo "====== Building ${TEST_SUITE}/$TEST_NAME ======"
    verilator --cc -f $TEST_FILE -Mdir "$OUT_DIR" --prefix Vtop --exe "$@"

    make -C "$OUT_DIR" -f Vtop.mk -j`nproc` #OPT="-g -Og"

    echo "====== Running ${TEST_SUITE}/$TEST_NAME ======"
    if [[ -z "$REPEAT" ]]; then
        $OUT_DIR/Vtop | tee "$ACTUAL_OUT"
        echo -n
        if [[ ! "$(cat "$ACTUAL_OUT")" == *"$(cat "$EXPECTED_OUT")"* ]]; then
            echo "Output is different than expected!"
            exit 1
        fi
    else
        for i in $(seq 1 $REPEAT); do
            echo "-----> test run $i"
            $OUT_DIR/Vtop | tee "$ACTUAL_OUT"
            echo
            if [[ ! "$(cat "$ACTUAL_OUT")" == *"$(cat "$EXPECTED_OUT")"* ]]; then
                echo "Output is different than expected!"
                exit 1
            fi
        done
    fi
}

if [ -d $TEST ]; then
    TEST_SUITE=$(basename $TEST_SUITE)
    export TEST_DIR=$TEST
    # For each *.f file in test dir
    for TEST_FILE in $TEST_DIR/*.f; do
        run_test $TEST_FILE "$@"
    done
else
    TEST_SUITE=$(basename $(dirname $TEST_SUITE))
    export TEST_DIR=$(dirname $TEST)
    run_test $TEST "$@"
fi
