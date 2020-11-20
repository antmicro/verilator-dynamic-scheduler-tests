#!/bin/bash

set -e

pushd verilator/test_regress

function run() {
  file=$1
  timeout 15 ./driver.pl $file
}

run "$TEST_PATH"
