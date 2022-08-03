*** Settings ***
Documentation
#		       
#
# Links:               https://robotframework.transformidea.com/doxy/rfsshl_html/classSSHLibrary_1_1library_1_1SSHLibrary.html
...
...                    Notice how connections are handled as part of the suite setup and
...                    teardown. This saves some time when executing several test cases.
...
...                     Run the tests from cds-mpat directory on a target test system as:  run_cdslmo.sh <target-system>

Library                 SSHLibrary
Library                 Process
Library                 String
Library                 OperatingSystem
Suite Setup             Open Connection And Log In gz_server_15_122
Suite Teardown          Close All Connections
Resource                ../config/${environment}.robot

*** Variables ***
${prompt}               "# " 

*** Test Cases ***
Execute ivc smoke test suite
    [Documentation]       Execute ivc smoke test suite
    [Tags]                test_case_id=
    ${result}=            Execute Command    cd /public/python/api/casa/Tests/rade && ls -al
    Log to Console        ${\n}${result}
    ${result}=            Run Process        python3    rm_OCP-4_GZ.py  | tee rm_OCP-4_$(date +"%m_%d_%Y").log   shell=True  output_encoding=UTF-8
    
    #Log to Console        ${\n}${result.rc}
    #Should be equal as integers      ${result.rc}  0

#Example put_file_on_the_remote_machine :)     # not tracked
#    # GIVEN
#    SSHLibrary.File Should Not Exist        /home/rade/file.txt  # or Directory Should Not Exist
#    # WHEN
#    SSHLibrary.Put File  tests/file.txt     /home/rade
#    # THEN
#    SSHLibrary.File Should Exist            /home/rade/file.txt   # or Directory Should Exist
#    [Teardown]  Execute Command             rm /home/rade/file.txt

#For Loop Example :)                        # not tracked
#    :FOR    ${i}    IN RANGE    999999
#    \    Log  ${i}
#    \    Exit For Loop If    ${i} == 100
#    #\    Log    ${i}
#    Log   Exited


*** Keywords ***

Open Connection And Log In gz_server_15_122
    Open Connection     ${gz_server_15_122}
    Login               ${username}        ${password}    # login as root