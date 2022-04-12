#!/bin/bash

set -e

ROOT=$(dirname $(realpath $0))
export VERILATOR_ROOT=$ROOT/verilator

cd $ROOT/ext_tests
t/$1 --dynamic
