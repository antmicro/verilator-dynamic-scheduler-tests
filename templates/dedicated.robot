{{ test }}
    ${result} =    Run Process    ${EXECDIR}/test.sh    {{ test }}    timeout=20s
    Should Be Equal As Integers    ${result.rc}    0

