{{ test }}
    [Tags]     builtin    {{ tags }}
    ${result} =    Run Process    ${EXECDIR}/regression_single.sh    ${EXECDIR}/verilator/test_regress    {{ test }}    timeout={{ timeout }}    stderr=STDOUT
    Log    ${result.stdout}
    Run Keyword If    ${result.rc}==-15    Set Tags    timeout
    Should Be Equal As Integers    ${result.rc}    0

