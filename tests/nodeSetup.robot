*** Settings ***
Library    Collections
Library    RequestsLibrary

Suite Teardown  Delete All Sessions

*** Test Cases ***
Check node balance
    [Tags]  post
    Create Session  reckordskeeper  http://35.171.226.226:7194
    &{data}=  Create Dictionary  jsonrpc=1.0   id=curltext   method=getinfo
    &{headers}=  Create Dictionary  Content-Type=application/json   Authorization=Basic cmtycGM6MlRSSkxXYWZNMXJES2hMRFpHV2I1c2JXNmNoTk1peVpOcDdBSk03YnRGNjM=
    ${resp}=  Post Request  reckordskeeper  /  data=${data}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    Should Be True     ${resp.json()['result']['balance']}>0

#Send transaction without metadata
#    [Tags]  post
#    Create Session  reckordskeeper  http://35.171.226.226:7194
#    &{data}=  Create Dictionary  jsonrpc=1.0   id=curltext   method=getinfo
#    &{headers}=  Create Dictionary  Content-Type=application/json   Authorization=Basic cmtycGM6MlRSSkxXYWZNMXJES2hMRFpHV2I1c2JXNmNoTk1peVpOcDdBSk03YnRGNjM=
#    ${resp}=  Post Request  reckordskeeper  /  data=${data}  headers=${headers}
#    Should Be Equal As Strings  ${resp.status_code}  200
#    Should Be True     ${resp.json()['result']['balance']}>0

Get Addresses
    [Tags]  post
    Create Session  reckordskeeper  http://35.171.226.226:7194
    &{data}=  Create Dictionary  jsonrpc=1.0   id=curltext   method=getaddresses
    &{headers}=  Create Dictionary  Content-Type=application/json   Authorization=Basic cmtycGM6MlRSSkxXYWZNMXJES2hMRFpHV2I1c2JXNmNoTk1peVpOcDdBSk03YnRGNjM=
    ${resp}=    Post Request    reckordskeeper  /  data=${data}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${addLength}=   Get Length  ${resp.json()['result']}
    Should be True     ${addLength}>0

Generate New Address
    [Tags]  post
    Create Session  reckordskeeper  http://35.171.226.226:7194
    &{data}=  Create Dictionary  jsonrpc=1.0   id=curltext   method=getnewaddress
    &{headers}=  Create Dictionary  Content-Type=application/json   Authorization=Basic cmtycGM6MlRSSkxXYWZNMXJES2hMRFpHV2I1c2JXNmNoTk1peVpOcDdBSk03YnRGNjM=
    ${resp}=    Post Request    reckordskeeper  /  data=${data}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${addLength}=   Get Length  ${resp.json()['result']}
    Should be True     ${addLength}>0

Check Transaction Info
    [Tags]  post
    Create Session  reckordskeeper  http://35.171.226.226:7194
    ${param_list}=      Create List    1AxmuNL6sca59tbw3WAJCvjLdgBmuUq95DQfVo
    ${tuple} =    Evaluate    (10)
    Append to List     ${param_list}   ${tuple}
    &{data}=  Create Dictionary  jsonrpc=1.0   id=curltext   method=send    params=${param_list}
    &{headers}=  Create Dictionary  Content-Type=application/json   Authorization=Basic cmtycGM6MlRSSkxXYWZNMXJES2hMRFpHV2I1c2JXNmNoTk1peVpOcDdBSk03YnRGNjM=
    ${resp}=    Post Request    reckordskeeper  /  data=${data}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

    ${txid}=    Set Variable	${resp.json()['result']}

    ${param_list}=      Create List    ${txid}
    &{tx_data}=  Create Dictionary  jsonrpc=1.0   id=curltext   method=getwallettransaction    params=${param_list}
    &{tx_headers}=  Create Dictionary  Content-Type=application/json   Authorization=Basic cmtycGM6MlRSSkxXYWZNMXJES2hMRFpHV2I1c2JXNmNoTk1peVpOcDdBSk03YnRGNjM=
    ${tx_resp}=    Post Request    reckordskeeper  /  data=${tx_data}  headers=${tx_headers}
    Should Be Equal As Strings  ${tx_resp.status_code}  200
    Should Not Be Empty     ${resp.json()['result']}>0