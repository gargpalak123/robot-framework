*** Settings ***
Documentation     Testing Proclniq test suites
Library         SeleniumLibrary
Resource        ../resources/common_test.robot
Test Setup      Open Browser    ${BaseURL}    ${BROWSER}
Test Teardown   Close All Browsers

*** Variables ***
${BaseURL}               https://procliniq.in/login
${BROWSER}               Chrome
${expected_url}          https://procliniq.in/Dashboard
${Doctor_username}        proeffico@gmail.com
${Doctor_password}        secret
${faker}                Faker

*** Test Cases ***
Run Doctor Login And Common Cases
    [Tags]    doctor    positive
    Run Keyword    Doctor Login Test
    Run Keyword    Run Common Cases
    Run Keyword    Close Browser

*** Keywords ***
Doctor Login Test
    [Tags]    doctor    positive
    Open Browser         ${BaseURL}  ${BROWSER}
    click button   xpath=//*[@id="navbarTogglerDemo02"]/ul/li/a/b
    Input Text      id=email   ${Doctor_username}
    Input Password  id=password  ${Doctor_password}
    Click Element   xpath=//*[@id="login"]/div/div/div[2]/div/div[2]/form/div[4]/div/button
    Sleep    2s    # Wait for the login to complete, adjust as needed
    Capture Page Screenshot    login_success.png
    ${dashboard_url} =  Get Location
    Should Be Equal  ${dashboard_url}  ${expected_url}

*** Keywords ***
Run Common Cases
    [Tags]    common
    # Import common cases from an external file
    Run Keyword File    path/to/common_tests.robot
