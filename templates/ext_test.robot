{{ test }}
    [Tags]     ext_test    {{ tags }}
    ${result} =    Run Process    ${EXECDIR}/ext_single.sh    {{ test }}    timeout={{ timeout }}    stdout=robot_tests/ext_tests/{{ test }}.log    stderr=STDOUT
    Log    ${result.stdout}
    Run Keyword If    ${result.rc}==-15    Set Tags    timeout
    Should Be Equal As Integers    ${result.rc}    0

