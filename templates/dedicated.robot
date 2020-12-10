{{ test }}
    [Tags]     dedicated    {{ tags }}
    ${result} =    Run Process    ${EXECDIR}/test.sh    {{ test }}    timeout={{ timeout }}    stderr=STDOUT
    Log    ${result.stdout}
    Run Keyword If    ${result.rc}==-15    Set Tags    timeout
    Should Be Equal As Integers    ${result.rc}    0

