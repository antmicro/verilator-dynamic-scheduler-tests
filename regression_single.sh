#!/bin/bash

set -e

pushd "$1"
timeout 15 ./driver.pl "$2"
