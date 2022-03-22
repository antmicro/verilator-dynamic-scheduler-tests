#!/usr/bin/env bash

function patch {
    git -C ext_tests/submodules/Cores-$1 apply ../../../patches/$1.patch
}

patch SweRV
patch SweRV-EH2
patch SweRV-EL2
