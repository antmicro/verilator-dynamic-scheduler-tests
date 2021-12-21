#!/bin/bash

set -e

cd $(dirname $0)/verilator/test_regress
./driver.pl t/"$1"
