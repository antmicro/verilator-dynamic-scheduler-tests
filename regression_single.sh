#!/bin/bash

set -e

pushd "$1"
./driver.pl "$2"
