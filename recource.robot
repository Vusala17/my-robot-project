***Settings***
Library    RequestsLibrary

***Variables***
${BASE_URL}    https://automationexercise.com/api_list
${headers}      {'Content-Type': 'application/json', 'Accept': 'application/json'}



*** Keywords ***
Create API Session
    Create Session    api_session    ${BASE_URL}    headers=${headers}
    Create Session    automation_session    https://automationexercise.com
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}   200
