{{ test }}
    [Tags]     dedicated
    ${result} =    Run Process    ${EXECDIR}/test.sh    {{ test }}    timeout=120s    stderr=STDOUT
    Log    ${result.stdout}
    Should Be Equal As Integers    ${result.rc}    0

