*** Settings ***
Library    RequestsLibrary
Suite Setup    Create Session    ${SESSION_ALIAS}    ${BASE_URL}    headers=${HEADERS}    verify=True
Suite Teardown    Delete All Sessions

*** Variables ***
${SESSION_ALIAS}    automation_session
${BASE_URL}    https://automationexercise.com
${HEADERS}    {"Content-Type": "application/json", "Accept": "application/json"}
${e-mail}     vusala.kerimbeyli@gmail.com
${password}   Vusala1234

*** Test Cases ***

Get All Products List Should Return 200 And JSON
    ${response}=    GET On Session    ${SESSION_ALIAS}    /api/productsList
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    products

Post To All Products List Should Return 400
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/productsList
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()["responseCode"]}    ${400}
    Should Be Equal    ${response.json()["message"]}    This request method is not supported.

Get All Brands List Should Return 200 And JSON
    ${response}=    GET On Session    ${SESSION_ALIAS}    /api/brandsList
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    brands

Put To All Brands List Should Return 405
    ${response}=    PUT On Session    ${SESSION_ALIAS}    /api/brandsList
    Should Be Equal As Integers   ${response.status_code}    200
    Should Be Equal    ${response.json()["message"]}    This request method is not supported.
    Should Be Equal     ${response.json()["responseCode"]}    ${405}
  

Post To Search Product Should Return 200 And JSON
    ${data}=    Create Dictionary    search_product=jean
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/searchProduct    params=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()["responseCode"]}    ${400}
    Should Be Equal    ${response.json()["message"]}    Searched products list

Post To Search Product Without Parameter Should Return 400
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/searchProduct
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()["responseCode"]}    ${400}
    Should Contain    ${response.text}    Bad request, search_product parameter is missing in POST request.


Post To Verify Login With Valid Details Should Return 200
    ${data}=    Create Dictionary    email=${e-mail}    password=${password}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/brandsList    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    


Post To Verify Login Without Email Should Return 400
    ${data}=    Create Dictionary    password=${password}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/verifyLogin    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()["responseCode"]}   ${400}
    Should Contain    ${response.json()["message"]}    Bad request, email or password parameter is missing in POST request.

Delete To Verify Login Should Return 405
    ${response}=    DELETE On Session    ${SESSION_ALIAS}    /api/verifyLogin
    Should Be Equal As Integers   ${response.status_code}    200
    Should Be Equal    ${response.json()["message"]}    This request method is not supported.
    Should Be Equal     ${response.json()["responseCode"]}    ${405}
  

Post To Verify Login With Invalid Details Should Return 404
    ${data}=    Create Dictionary    password=Vusala1  e-mail=${e-mail}
    ${response}=    POST On Session    ${SESSION_ALIAS}    /api/verifyLogin    json=${data}
    Should Be Equal As Integers    ${response.status_code}   200
    Should Be Equal    ${response.json()["responseCode"]}   ${400}
    Should Contain   ${response.json()["message"]}    Bad request, email or password parameter is missing in POST request.