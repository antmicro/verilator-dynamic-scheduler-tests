#!/usr/bin/env bash

set -e

###############
# PREPARATION #
###############

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEST_DIR=$(realpath "tests/prot_lib")
TEST_NAME=$(basename "$TEST_DIR")

CPP_MAIN="$TEST_DIR/vmain.cpp"
SV_MAIN="$TEST_DIR/test.sv"

function check_file() {
  if [[ ! -e "$1" ]]; then
    echo "$2 for $TEST_NAME missing"
    exit 1
  fi
}

check_file "$CPP_MAIN" "CPP source"
check_file "$SV_MAIN" "SV source"

OUT_DIR="$SCRIPT_DIR/out/$TEST_NAME"
ACTUAL_OUT="$OUT_DIR/output"

mkdir -p $OUT_DIR

#########
# BUILD #
#########
verilator --output-split-cfuncs 1 --cc "$TEST_DIR/prot_lib.sv" -Mdir "$OUT_DIR/prot_lib" --prefix Vprot_lib --protect-lib prot_lib -CFLAGS "-DVL_THREADED"
verilator --output-split-cfuncs 1 --cc "$SV_MAIN" -Mdir "$OUT_DIR" --prefix Vtop --exe -o vmain "$OUT_DIR/prot_lib/prot_lib.sv" "$CPP_MAIN" -LDFLAGS "$OUT_DIR/prot_lib/libprot_lib.a -lpthread" -CFLAGS "-DVL_THREADED"

make -C "$OUT_DIR/prot_lib" -f Vprot_lib.mk
make -C "$OUT_DIR" -f Vtop.mk

#######
# RUN #
#######

$OUT_DIR/vmain
