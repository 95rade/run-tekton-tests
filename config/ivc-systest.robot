*** Variables ***

# SUT cluster specific info
${sut_url}            https://api.ivc-systest.casa.dev:6443
${sut_token}          sha256~hkHKMQO7PWA1D7HgF7N9zccQnIS4w2ymEji5aWyy4p8
${oc_login_token}     --token=sha256~hkHKMQO7PWA1D7HgF7N9zccQnIS4w2ymEji5aWyy4p8 --server=https://api.ivc-systest.casa.dev:6443
${oc_username}        kubeadmin
${oc_password}        J8kor-zosNp-mdPyg-diRUy

${prompt}               ]#              #  [root@

#
# API VARIABLES
#
${SYSTEM_NAME}		    ivc-systest.casa.dev          
${auth_url}             https://auth.${SYSTEM_NAME}/keycloak/realms/shasta/protocol/openid-connect
${api_url}              https://api.${SYSTEM_NAME}
###
### iDRAC stuff
###
${dm1_sw_mac}           b47af1c0953a       # b4\:7a\:f1\:c0\:95\:3a  {dm1 examples
${dm2_sw_mac}
${dm3_sw_mac}
${dm4_sw_mac}
