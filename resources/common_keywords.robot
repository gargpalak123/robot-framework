*** Variables ***
${BROWSER}    Chrome
${BaseURL}    https://procliniq.in
${doctor_username}    palakdoctor@gmail.com
${doctor_password}    1234567890
${admin_username}     poojasuper@gmail.com
${admin_password}     1234567890
${reception_username}  palakreception@gmail.com
${reception_password}   1234567890
${expected_dashboard_url}   ${BaseURL}/Dashboard
${expected_url}      ${BaseURL}/Today-Summary}
${expected_error_message}     Email or password invalid.
${doctor_invalid_password}   123
${reception_invalid_password}   124
${admin_invalid_password}   156
${doctor_invalid_username}  testing@gmail.com
${reception_invalid_username}   test@gmail.com
${admin_invalid_username}    test10@gmail.com

*** Keywords ***
Set Credentials
    [Arguments]    ${role}
    ${credentials}=    Run Keyword If    '${role}' == 'Doctor'    Set Doctor Credentials
    ...    ELSE IF    '${role}' == 'Admin'    Set Admin Credentials
    ...    ELSE IF    '${role}' == 'Reception'    Set Reception Credentials
    [Return]    ${credentials}

Set Doctor Credentials
    [Return]    ${doctor_username}    ${doctor_password}

Set Admin Credentials
    [Return]    ${admin_username}    ${admin_password}

Set Reception Credentials
    [Return]    ${reception_username}    ${reception_password}

Login Page UI Validation
    ${login_button_locator} =  Set Variable    //div[@id='navbarTogglerDemo02']/ul/li/a/b

    # Wait for the page to load
    Wait Until Page Contains Element    ${login_button_locator}    timeout=30s

    # Use explicit waits to ensure the element is fully loaded
    Wait Until Element Is Visible    ${login_button_locator}    timeout=30s  # Adjust the timeout as needed

    # Check if the login button is enabled
    Wait Until Element Is Enabled    ${login_button_locator}    timeout=30s

    # Click the login button
    Click Element    ${login_button_locator}
    Capture Page Screenshot

Common Login Process
    [Arguments]    ${username}    ${password}
    Input Text    id:email    ${username}
    Input Text    id:password    ${password}
    ${login_button} =      Set Variable    //button[@type="submit"]


    # Wait for the page to load
    Wait Until Page Contains Element   ${login_button}    timeout=30s

    # Use explicit waits to ensure the element is fully loaded
    Wait Until Element Is Visible    ${login_button}    timeout=30s  # Adjust the timeout as needed
    Wait Until Element Is Enabled    ${login_button}    timeout=30s

    ${is_enabled} =    Run Keyword And Return Status    Element Should Be Enabled    ${login_button}

    # Click the login button if it's enabled, otherwise scroll and click
    Run Keyword If    ${is_enabled}
    ...    Click Element    ${login_button}
    ...    ELSE
    ...    Scroll Element Into View    ${login_button}  # Scroll to the login button if it's not visible
    ...    Wait Until Element Is Visible    ${login_button}    timeout=10s
    ...    Wait Until Element Is Enabled    ${login_button}    timeout=10s
    ...    Click Element    ${login_button}
    Capture Page Screenshot

Dashboard Redirection
    [Arguments]    ${expected_dashboard_url}
    ${CurrentURL} =    Get Location
    Run Keyword If    '${CurrentURL}' == '${expected_dashboard_url}'
    ...    Log    Test Passed - Current URL: ${CurrentURL}
    ...    ELSE
    ...    Log    Test Failed - Current URL: ${CurrentURL}
    Capture Page Screenshot

Verify Home Page Title
    [Documentation]    Verifies the title of the home page.
    ${title} =    Get Title
    Should Be Equal As Strings    ${title}    ProCliniq
    Log    Home Page Title Verified: ${title}
    Capture Page Screenshot

Common Logout
    [Documentation]    Tests the logout functionality.
    Wait Until Element Is Visible    xpath://span[@class='d-sm-inline d-none']   timeout=10s
    Click Element    xpath://span[@class='d-sm-inline d-none']
    Wait Until Page Contains Element    //b[normalize-space()='Login']
    ${current_url}=    Get Location
    Log   ${current_url}
    Should Be Equal    ${current_url}    https://procliniq.in/login

Common Check Required Field Toggle
    [Arguments]    ${field_locator}    ${required_status}
    [Documentation]    Verifies that the required field toggle is displayed based on the required status.
    Run Keyword If    '${required_status}' == 'true'
    ...    Element Should Be Visible    ${field_locator}
    Run Keyword If    '${required_status}' == 'false'
    ...    Element Should Not Be Visible    ${field_locator}


Dashboard Element UI Check
    [Arguments]    @{element_locators}
    FOR    ${locator}    IN    @{element_locators}
        # Wait for the element to appear
        Wait Until Page Contains Element    ${locator}    timeout=180

        # Check if the element is visible
        Wait Until Element Is Visible    ${locator}    timeout=180
        sleep   5

        # Get the text of the element
        ${element_name} =    Get Text    ${locator}

        # Check if the element is enabled
        ${is_enabled} =    Run Keyword And Return Status    Element Should Be Enabled    ${locator}
        Run Keyword If    ${is_enabled}
            Log    ${element_name} is enabled; verification is successful
        ...    ELSE
            Log    ${element_name} is NOT enabled; verification failed
            Continue For Loop

        # Click the element
        Click Element    ${locator}

        # Sleep for some time
        Sleep    5

        # Determine the URL to go to based on the element name
        Run Keyword If    '${element_name}' == "Today's Appointments"
            ${page_url} =    Set Variable    https://procliniq.in/view-appointment
        ...    ELSE IF    '${element_name}' == "Total Appointments"
            ${page_url} =    Set Variable    https://procliniq.in/All-Appointment
        ...    ELSE IF    '${element_name}' == "Today Doctor leave"
            ${page_url} =    Set Variable    https://procliniq.in/doctors
        ...    ELSE IF    '${element_name}' == "Cancelled Appt. (Today)"
            ${page_url} =    Set Variable    https://procliniq.in/view-appointment
        ...    ELSE
            Log    Unknown element name: ${element_name}

        # Go back to the dashboard URL
        Go Back

        # Open the determined page URL
        Go To Page    ${page_url}

    END



Input Username and Password
    [Arguments]  ${username} ${password}
    ${login_button_locator} =  Set Variable    //div[@id='navbarTogglerDemo02']/ul/li/a/b

    # Wait for the page to load
    Wait Until Page Contains Element    ${login_button_locator}    timeout=30s

    # Use explicit waits to ensure the element is fully loaded
    Wait Until Element Is Visible    ${login_button_locator}    timeout=30s  # Adjust the timeout as needed

    # Check if the login button is enabled
    Wait Until Element Is Enabled    ${login_button_locator}    timeout=30s

    # Click the login button
    Click Element    ${login_button_locator}
    Input Text    id:email    ${username}
    Input Text    id:password    ${password}

Click Remember Me Checkbox
     page should not contain checkbox    id:remember
     select checkbox    remember

Submit Login Form
     ${login_button} =      Set Variable    //button[@type="submit"]

    # Wait for the page to load
    Wait Until Page Contains Element   ${login_button}    timeout=30s

    # Use explicit waits to ensure the element is fully loaded
    Wait Until Element Is Visible    ${login_button}    timeout=30s  # Adjust the timeout as needed
    Wait Until Element Is Enabled    ${login_button}    timeout=30s

    ${is_enabled} =    Run Keyword And Return Status    Element Should Be Enabled    ${login_button}
    Click Element    ${login_button}
    Capture Page Screenshot


Validate Remember Me Functionality
    [Arguments]  ${expected_state=ON}
    ${state} =  Get Element Attribute  remember_me_checkbox@checked
    Run Keyword If  '${state}' == '${expected_state}'
        Log  "Remember Me" is working as expected
    ...  ELSE
        Log  "Remember Me" is not working as expected


#Check Error Message
#    [Arguments]    ${expected_error_message}
#    Wait Until Element Is Visible    //strong[normalize-space()='Email or password invalid.']   timeout=60s
#     ${actual_message}=    Get Text      //strong[normalize-space()='Email or password invalid.']
#    Log     ${message}
#    Should Be Equal    ${actual_message}    ${expected_message}
#    Run Keyword If    '${message}' == '${expected_error_message}'
#    ...    Log    Test Passed: Expected error message displayed
#    ...    ELSE
#    ...    Log    Test Failed: Expected error message not displayed
##    Capture Page Screenshot
#




#Common Login
#    [Arguments]    ${username}    ${password}    ${role}
#    Go To    ${BaseURL}/login
#    Maximize Browser Window
#    Wait Until Page Contains Element    //b[normalize-space()='Login']
#    ${login_buttons} =    Get WebElements    //b[normalize-space()='Login']
#    # Verify the UI and CSS of the first login button
#    ${login_button_1} =    Set Variable    ${login_buttons}[0]
#    Element Should Be Visible
#
#Verify Class Attribute
#    ${class_attribute} =    Set Variable    h2 nav-item nav-link
#    ${contains_nav_link} =    Should Contain Substring    ${class_attribute}    nav-item nav-link
#    ${contains_h2} =    Should Contain Substring    ${class_attribute}    h2
#    Run Keyword If    ${contains_nav_link} and ${contains_h2}
#    ...    Log    Element has the expected class attributes 'nav-item nav-link' and 'h2'
#    ...    ELSE
#    ...    Log    Element does not have the expected class attributes
#
#
#    Click Element    ${login_button_1}  # Click the first login button
#
#    # Rest of your login steps remain the same
#
#    Wait Until Page Contains Element    id:email
#    Input Text    id:email    ${username}
#    Wait Until Page Contains Element    id:password
#    Input Text    id:password    ${password}
#    Click Element    css=.h2 > b
#    Wait Until Element Is Enabled    css=button[type='submit']
#    Capture Page Screenshot
#    Execute JavaScript    window.scrollTo(0, document.querySelector("button[type='submit']").getBoundingClientRect().top)
#    ${current_url}=    Get Location
#    ${actual_role}=    Run Keyword If    '${current_url}' == ${expected_dashboard_url}    Set Variable    Doctor
#    ...    ELSE IF    '${current_url}' == 'https://procliniq.in/Today-Summary'    Set Variable    Admin
#    ...    ELSE IF    '${current_url}' == 'https://procliniq.in/reception-dashboard'    Set Variable    Reception
#    ...    ELSE    Set Variable    Unknown
#    Run Keyword If    '${actual_role}' == '${role}'    Log    Test Passed - Redirected to ${role} dashboard
#    ...    ELSE    Fail    Expected role: ${role}, Actual role: ${actual_role}
#    Capture Page Screenshot
#
#    # Verify the home page title
#    ${title}=    Get Title
#    Title Should Be    Your Expected Title  # Replace with your expected title
#    Log    Home Page Title Verified: ${title}
#    Capture Page Screenshot
#
#Common Check Doctor Dashboard
#    [Arguments]    ${expected_dashboard_url}
#    Wait Until Page Contains    ${expected_dashboard_url}
#    Capture Page Screenshot
#    ${current_url}=    Get Location
#    Run Keyword If    '${current_url}' == ${expected_dashboard_url}
#    ...    Log    Test Passed - Redirected to ${expected_dashboard_url}
#    ...    ELSE    Fail    Expected URL: ${expected_dashboard_url}, Actual URL: ${current_url}
#    Capture Page Screenshot
#








##Validate Empty Login Error
##    [Arguments]    ${actual_message}    ${expected_message}
##    Run Keyword If    '${expected_message}' == 'Expected Empty Login Error Message'
##    ...    Element Should Be Visible    ////div[@class='row justify-content-center']
##    ...    Element Text Should Be    ////div[@class='row justify-content-center']  ${expected_message}
##    Capture Page Screenshot
##    Run Keyword If    '${expected_message}' != 'Expected Empty Login Error Message'
##    ...    Log    Test Failed - Expected empty login error message not displayed: ${expected_message}
##    ...    Capture Page Screenshot
##
##Validate Invalid Password Or Username Error
##    [Arguments]    ${actual_message}    ${expected_message}
##    Run Keyword If    '${expected_message}' == 'Expected Invalid Password Error Message'
##    ...    Element Should Be Visible    ////*[@id="login"]/div/div/div[2]/div/div[2]/form/div[1]/div/span/strong
##    ...    Element Text Should Be    ////*[@id="login"]/div/div/div[2]/div/div[2]/form/div[1]/div/span/strong    ${expected_message}
##    Capture Page Screenshot
##    Run Keyword If    '${expected_message}' != 'Expected Invalid Password Error Message'
##    ...    Log    Test Failed - Expected invalid password or username error message not displayed: ${expected_message}
##    ...    Capture Page Screenshot
#
Common Add Patient
    [Arguments]    ${patient_data}    ${use_close_button}
    ${current_url}=    Get Location
    ${expected_url}=    Set Variable    https://procliniq.in/Today-Summary
    Run Keyword If    '${current_url}' != '${expected_url}'    Test Login    ${patient_data["username"]}    ${patient_data["password"]}
    Go To    ${expected_url}
    Wait Until Page Contains Element    //a[normalize-space()='Add Patient']
    Click Element    //a[normalize-space()='Add Patient']
    Input Patient Details    ${patient_data}
    Run Keyword If    ${use_close_button}    Close Button Validation
    ...    ${patient_data}
    Input Patient Details
        [Arguments]    ${patient_data}
        Wait Until Element Is Visible    id:user_name
        Input Text    id:user_name    ${patient_data["name"]}
        Wait Until Element Is Visible    id:number
        Input Text    id:number    ${patient_data["number"]}
        Wait Until Element Is Visible    name:pincode
        Input Text    name:pincode    ${patient_data["pincode"]}
        Wait Until Element Is Visible    id:address
        Input Text    id:address    ${patient_data["address"]}
        Wait Until Element Is Visible    name:locality
        Input Text    name:locality    ${patient_data["locality"]}
        Wait Until Element Is Clickable    id:blood_group
        Click Element    id:blood_group
        Wait Until Element Is Clickable    xpath://option[. = 'A']
        Click Element    xpath://option[. = 'A']
        Wait Until Element Is Clickable    css:.selectBox > .overSelect
        Click Element    css:.selectBox > .overSelect
        Wait Until Element Is Clickable    css:label:nth-child(1) > input
        Click Element    css:label:nth-child(1) > input
        Wait Until Element Is Visible    id:user_email
        Input Text    id:user_email    ${patient_data["email"]}
        Wait Until Element Is Visible    name:sec_mob_no
        Input Text    name:sec_mob_no    ${patient_data["alt_number"]}
        Wait Until Element Is Visible    id:birthday
        Input Text    id:birthday    ${patient_data["birthday"]}
        Wait Until Element Is Visible    name:city
        Input Text    name:city    ${patient_data["city"]}
        Wait Until Element Is Clickable    id:gender
        Click Element    id:gender
        Wait Until Element Is Clickable    xpath://option[. = 'female']
        Click Element    xpath://option[. = 'female']
        Wait Until Element Is Visible    name:referred_by
        Input Text    name:referred_by    ${patient_data["refer_by"]}
        Wait Until Element Is Clickable    css:.selectBox > .overSelect
        Click Element    css:.selectBox > .overSelect
        Wait Until Element Is Clickable    css:label:nth-child(1) > input
        Click Element    css:label:nth-child(1) > input

Common Verify Redirect to Appointment Page
    [Documentation]    Verifies that the system redirects to the Appointment Booking page.
    ${current_url}=    Get Location
    ${expected_url}=    Set Variable    https://procliniq.in/Appointment-Booking  # Define the expected URL
    Should Be Equal    ${current_url}    ${expected_url}
    Log    Test Passed - Redirected to Appointment Booking Page

Close Button Validation
    [Arguments]    ${patient_data}
    ${full_name_value}=    Get Element Attribute    id:user_name    value
    ${email_value}=    Get Element Attribute    id:user_email    value
    ${current_url}=    Get Location
    ${expected_url}=    Set Variable    https://procliniq.in/Add-Patient
    Should Be Equal    ${full_name_value}    ""
    Should Be Equal    ${email_value}    ""
    Should Be Equal    ${current_url}    ${expected_url}
    Log    Test Passed - Close Button Validation
#
#Book Appointment
#    [Arguments]    ${date}
#    # Implement your appointment booking logic here
#    # Fill out appointment form, select the date, and submit
#
#View Appointment
#    # Implement your logic to navigate to the view appointment page
#    # Click the "View" button on the specific appointment you want to view
#
#Verify Redirect to View Appointment Page
#    [Arguments]    ${page_type}
#    # Verify that the page redirects to the correct URL based on the appointment date
#    ${current_url}    Get Location
#    ${expected_url}    Set Variable    ${BaseURL}/Patient-All-information?a=3900
#    Run Keyword If    '${page_type}' == 'today'    Should Be Equal As Strings    ${current_url}    ${expected_url}?type=today
#    Run Keyword If    '${page_type}' == 'future'   Should Be Equal As Strings    ${current_url}    ${expected_url}?type=future