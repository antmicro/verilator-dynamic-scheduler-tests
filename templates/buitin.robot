{{ test }}
    ${result} =    Run Process    ${EXECDIR}/regression_single.sh    ${EXECDIR}/verilator/test_regress    {{ test }}    timeout=15s
    Should Be Equal As Integers    ${result.rc}    0

