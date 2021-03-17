#!/usr/bin/env bash

set -e

###############
# PREPARATION #
###############

if [[ ! -d "$1" ]]; then
  echo "Usage: $0 <test directory>"
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEST_DIR=$(realpath "$1")
TEST_NAME=$(basename "$TEST_DIR")

CPP_MAIN="$TEST_DIR/vmain.cpp"
SV_MAIN="$TEST_DIR/test.sv"
EXPECTED_OUT="$TEST_DIR/test.out"

function check_file() {
  if [[ ! -e "$1" ]]; then
    echo "$2 for $TEST_NAME missing"
    exit 1
  fi
}

check_file "$CPP_MAIN" "CPP source"
check_file "$SV_MAIN" "SV source"
check_file "$EXPECTED_OUT" "Expected output"

OUT_DIR="$SCRIPT_DIR/out/$TEST_NAME"
ACTUAL_OUT="$OUT_DIR/output"

mkdir -p $OUT_DIR

#########
# BUILD #
#########

verilator --output-split-cfuncs 1 --cc "$SV_MAIN" -Mdir "$OUT_DIR" --prefix Vtop --exe -o vmain "$CPP_MAIN" -LDFLAGS "-lpthread" -CFLAGS "-DVL_THREADED"

make -C "$OUT_DIR" -f Vtop.mk

################
# RUN & VERIFY #
################

if [[ -z "$2" ]]; then
  $OUT_DIR/vmain | tee "$ACTUAL_OUT"
else
  for i in $(seq 1 $2); do
    echo "==> Test run $i"
    $OUT_DIR/vmain | tee "$ACTUAL_OUT"
    echo -n
    if [[ ! "$(cat "$ACTUAL_OUT")" == *"$(cat "$EXPECTED_OUT")"* ]]; then
      echo "Output is different than expected!"
      exit 1
    fi
  done
fi
