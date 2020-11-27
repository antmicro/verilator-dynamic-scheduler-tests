{{ test }}
    [Tags]     dedicated    {{ tags }}
    ${result} =    Run Process    ${EXECDIR}/test.sh    {{ test }}    timeout={{ timeout }}    stderr=STDOUT
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0

