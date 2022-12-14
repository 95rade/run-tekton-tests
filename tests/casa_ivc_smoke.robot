*** Settings ***
Documentation
#		       
#
# Links:               https://robotframework.transformidea.com/doxy/rfsshl_html/classSSHLibrary_1_1library_1_1SSHLibrary.html
...
...                    Notice how connections are handled as part of the suite setup and
...                    teardown. This saves some time when executing several test cases.
...
...                     Run the tests from cds-mpat directory on a target test system as:  run_sutx.sh <target-system>

Library                 SSHLibrary
Library                 Process
Library                 String
Library                 OperatingSystem
#Suite Setup             Open Connection and Log In OCP Cluster
Suite Teardown          Close All Connections
Resource                ../config/${environment}.robot

*** Variables ***
${prompt}               "# " 

*** Test Cases ***
Verify all Nodes are in Ready state
    [Documentation]       Verify all k8s nodes are in Ready state
    [Tags]                test_case_id=
    Open Connection and Log In OCP Cluster
    ${result2}=           Execute Command        oc     get     nodes
    Log to Console        ${\n}${result2}
    Should Not Contain 	  ${result2}    Not-Ready    ignore_case=True
    Should Match Regexp   ${result2}    node-[1-9]


Verify no pods are in bad state
    [Documentation]     Verify no pods are in bad state
    [Tags]              test_case_id=
    #${result}=          Run Process        oc     login    ${oc_login_token}
    #Log To Console      ${\n}${result.stdout}
    ${result2}=          Execute Command        oc     get      pods    -n casa
    #Log to Console      ${\n}${result2}
    Should Not Contain  ${result2}                Error           ignore_case=True
    Should Not Contain  ${result2}                Terminating     ignore_case=True
    Should Not Contain  ${result2}                ContainerCreating    ignore_case=True
    Should Not Contain  ${result2}                CrashLoopBackOff     ignore_case=True

Verify smf operator is running in the cluster
    [Documentation]     Verify smf operator is running in the cluster
    [Tags]              test_case_id=
    #${result}=          Run Process        oc     login    ${oc_login_token}
    #Log To Console      ${\n}${result.stdout}
    ${result2}=          Execute Command        oc     get      pods    -A  |  grep -i casa-smf
    Log to Console      ${\n}${result2}
    Should Contain      ${result2}              casa-smf           ignore_case=True

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

Open Connection and Log In OCP Cluster
    Open Connection     ${jumpbox}      # we don't use ssh
    Login               ${ocp_user}      ${ocp_password}
