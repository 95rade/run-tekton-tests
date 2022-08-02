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
Suite Setup             Log In OCP cluster
Suite Teardown          Close All Connections
Resource                ../config/${environment}.robot

*** Variables ***
${prompt}               "# " 

*** Test Cases ***
Verify all Nodes are in Ready state
    [Documentation]       Verify all k8s nodes are in Ready state
    [Tags]                test_case_id=
    #${result}=            Run Process        oc    login    ${oc_login_token} 
    #Log to Console        ${\n}${result.stdout}
    ${result2}=            Run Process        oc     get     nodes
    Log to Console        ${\n}${result2.stdout}
    Should Not Contain 	  ${result2.stdout}    Not-Ready    ignore_case=True
    Should Match Regexp   ${result2.stdout}    node-[1-9]


Verify no pods are in bad state
    [Documentation]     Verify no pods are in bad state
    [Tags]              test_case_id=
    #${result}=          Run Process        oc     login    ${oc_login_token}
    #Log To Console      ${\n}${result.stdout}
    ${result2}=          Run Process        oc     get      pods    -A
    #Log to Console      ${\n}${result2.stdout}
    Should Not Contain  ${result2.stdout}                Error           ignore_case=True
    Should Not Contain  ${result2.stdout}                Terminating     ignore_case=True
    Should Not Contain  ${result2.stdout}                ContainerCreating    ignore_case=True
    Should Not Contain  ${result2.stdout}                CrashLoopBackOff     ignore_case=True

Verify smf operator is running in the cluster
    [Documentation]     Verify smf operator is running in the cluster
    [Tags]              test_case_id=
    #${result}=          Run Process        oc     login    ${oc_login_token}
    #Log To Console      ${\n}${result.stdout}
    ${result2}=          Run Process        oc     get      pods    -A  |  grep -i casa-smf  shell=True
    Log to Console      ${\n}${result2.stdout}
    Should Contain      ${result2.stdout}              casa-smf           ignore_case=True

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

#####################################
#### STANDALONE worker VM TESTS #####
#####################################

# TBD

*** Keywords ***

Remote Bash  
    [Arguments]  ${command}  
    [Documentation]  Runs a given terminal command on remote server and returns terminal output.  

    ${test} =    SSHLibrary.Execute Command    ${command}
    Return From Keyword   ${test}

####

Log In OCP cluster
    #Open Connection     ${lustre-client}    # we don't use ssh
    Login               ${oc_username}      ${oc_password}
