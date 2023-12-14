*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Doctor Login Test
    Open Browser    http://your_doctor_login_page.com    chrome
    Input Text      ${UsernameLocator}    doctor_username
    Input Password  ${PasswordLocator}    doctor_password
    Click Button    ${LoginButtonLocator}
    Sleep    2s    # Wait for the login to complete, adjust as needed
    Capture Page Screenshot    doctor_login_success.png    # Capture a screenshot for verification




