{{ test }}
    [Tags]     builtin
    ${result} =    Run Process    ${EXECDIR}/regression_single.sh    ${EXECDIR}/verilator/test_regress    {{ test }}    timeout=30s    stderr=STDOUT
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0

