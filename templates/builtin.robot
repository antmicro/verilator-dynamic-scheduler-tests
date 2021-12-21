{{ test }}
    [Tags]     builtin    {{ tags }}
    ${result} =    Run Process    ${EXECDIR}/regression_single.sh    {{ test }}    timeout={{ timeout }}    stdout=robot_tests/builtin/{{ test }}.log    stderr=STDOUT
    Log    ${result.stdout}
    Run Keyword If    ${result.rc}==-15    Set Tags    timeout
    Should Be Equal As Integers    ${result.rc}    0

