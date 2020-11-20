{{ test }}
    ${result} =    Run Process    ${EXECDIR}/test.sh    {{ test }}    timeout=15s
    Should Be Equal As Integers    ${result.rc}    0

