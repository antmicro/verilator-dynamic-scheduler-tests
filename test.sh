#!/usr/bin/env bash

set -e

###############
# PREPARATION #
###############

if [[ ! -d "$1" ]]; then
  echo "Usage: $0 <test directory>"
  exit 1
fi

export REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export TEST_DIR=$(realpath "$1")
TEST_SUITE_NAME=$(basename "$TEST_DIR")

function check_file() {
    if [[ ! -e "$1" ]]; then
        echo "$3 for $2 missing"
        exit 1
    fi
}

# For each *.f file in test dir
for TEST_FILE in $TEST_DIR/*.f; do
    TEST_NAME=$(basename ${TEST_FILE%.*})
    EXPECTED_OUT="${TEST_FILE%.*}.out"
    check_file $EXPECTED_OUT "$TEST_SUITE_NAME/$TEST_NAME" "Expected output"

    OUT_DIR="$REPO_DIR/out/$TEST_SUITE_NAME/$TEST_NAME"
    ACTUAL_OUT="$OUT_DIR/output"
    mkdir -p $OUT_DIR

    #########
    # BUILD #
    #########
    verilator --dynamic --cc -f $TEST_FILE -Mdir "$OUT_DIR" --prefix Vtop --exe

    make -C "$OUT_DIR" -f Vtop.mk -j`nproc` #OPT="-g -Og"

    ################
    # RUN & VERIFY #
    ################
    echo "====== Testing ${TEST_SUITE_NAME}/$TEST_NAME ======"
    if [[ -z "$2" ]]; then
        $OUT_DIR/Vtop | tee "$ACTUAL_OUT"
        echo -n
        if [[ ! "$(cat "$ACTUAL_OUT")" == *"$(cat "$EXPECTED_OUT")"* ]]; then
            echo "Output is different than expected!"
            exit 1
        fi
    else
        for i in $(seq 1 $2); do
            echo "==> Test run $i"
            $OUT_DIR/Vtop | tee "$ACTUAL_OUT"
            echo
            if [[ ! "$(cat "$ACTUAL_OUT")" == *"$(cat "$EXPECTED_OUT")"* ]]; then
                echo "Output is different than expected!"
                exit 1
            fi
        done
    fi
done
