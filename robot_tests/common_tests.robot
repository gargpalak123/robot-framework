*** Settings ***
Documentation     Testing Proclniq test suites
Library         SeleniumLibrary
Resource        ../resources/common_keywords.robot
Test Setup     Open Browser    ${BaseURL}    ${BROWSER}
Test Teardown  Close All Browsers

*** Test Cases ***
*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    Faker
Library    OperatingSystem

Suite Setup    Open Browser    ${BaseURL}    ${BROWSER}
Suite Teardown    Close Browser

*** Variables ***
${BaseURL}               https://mavi.proeffico.com
${BROWSER}               Chrome
${expected_url}          https://mavi.proeffico.com/dashboard
${ExpectedValidURL}      /merchantView
${ExpectedInvalidURL}    /errorPage
${valid_username}        proeffico@gmail.com
${valid_password}        secret
${faker}                Faker

*** Test Cases ***
Setup Test Data
    ${random_name} =    Generate Random String    8    [LETTERS]
    ${random_email} =   Generate Random Email
    ${random_phone} =   Generate Random Phone Number
    ${random_password} = Generate Random String    12    [LETTERS][DIGITS]
    Set Suite Variable    ${random_name}
    Set Suite Variable    ${random_email}
    Set Suite Variable    ${random_phone}
    Set Suite Variable    ${random_password}



Add Patient With Valid Data
    [Documentation]    Add Mavi User With Valid Data Test Case
    [Tags]    add-mavi-user
    ${valid_dropdown_data} =   Create List  Male    Sales
    Run Keyword    Add Mavi User Template    ${random_name}    ${random_email}    ${random_phone}    ${random_password}    ${valid_dropdown_data}    ${expected_add_url}

Add Patient With Invalid Data
    [Documentation]    Add Mavi User With Invalid Data Test Case
    [Tags]    add-mavi-user
    ${valid_dropdown_data} =   Create List   Male    Sales
    Run Keyword    Add Mavi User Template    ${random_email}    ${random_name}    ${random_phone}    ${random_password}    ${invalid_dropdown_data}    ${expected_add_url}


Add Patient With Duplicate Data
    [Documentation]    Add Mavi User With Duplicate Data Test Case
    [Tags]    add-mavi-user
    ${duplicate_name} =    Generate Random String    8    [LETTERS]
    ${duplicate_email} =    Generate Random Email
    ${duplicate_phone} =    Generate Random Phone Number
    ${duplicate_password} =    Generate Random String    12    [LETTERS][DIGITS]
    ${valid_text_field_data} =    Create List    ${duplicate_name}   ${duplicate_email}  ${duplicate_phone}   ${duplicate_password}
    ${valid_dropdown_data} =   Create List  Male    Sales
    Run Keyword    Add Mavi User Template    ${valid_text_field_data}    ${valid_dropdown_data}    ${expected_add_url}
    ${duplicate_text_field_data} =    Create List    ${duplicate_name}   ${duplicate_email}  ${duplicate_phone}   ${duplicate_password}
    ${duplicate_dropdown_data} =   Create List  Male    Sales
    Run Keyword    Add Mavi User Template    ${duplicate_text_field_data}    ${duplicate_dropdown_data}    ${expected_add_url}



Add Patient With Field Validation Data
    [Documentation]    Add Mavi User With Field Validation Data Test Case
    [Tags]    add-mavi-user
    ${fieldvalidation_text_field_data} =    Create List    ${random_name}    invalid_email@example    invalid_phone    ${random_password}
    ${fieldvalidation_dropdown_data} =   Create List   Male    Sales
    Run Keyword    Add Mavi User Template    ${fieldvalidation_text_field_data}    ${fieldvalidation_dropdown_data}    ${expected_add_url}


Add Patient With Mandatory Data
    [Documentation]    Add Mavi User With Mandatory Data Test Case
    [Tags]    add-mavi-user
    ${mandatoryfield_text_field_data} =    Create List    ${random_name}       ''     ${random_phone}    ${random_password}
    ${mandatoryfield_dropdown_data} =   Create List   Male    ''
    Run Keyword    Add Mavi User Template    ${mandatoryfield_text_field_data}    ${mandatoryfield_dropdown_data}    ${expected_add_url}

Add Patient With Empty Data
    [Documentation]    Add Mavi User With Empty Data Test Case
    [Tags]    add-mavi-user
    ${empty_text_field_data} =    Create List    ''       ''    ''     ''
    ${empty_dropdown_data} =   Create List   ''    ''
    Run Keyword    Add Mavi User Template    ${empty_text_field_data}    ${empty_dropdown_data}    ${expected_add_url}

*** Keywords ***
Login Template
    [Arguments]    ${username}    ${password}    ${expected_url}
    Input Text    id=email    ${username}
    Input Text    id=password    ${password}
    Click Button    xpath=//button[contains(text(),'Sign in')]
    Sleep    5
    ${dashboard_url} =  Get Location
    Should Be Equal  ${dashboard_url}  ${expected_url}




Scenario 7: Dashboard Element UI Check
    [Tags]  common  doctor  dashboard  ui  verification
    [Documentation]  Verify UI elements on the dashboard
    Maximize Browser Window
    Login Page UI Validation
    Common Login Process    ${doctor_username}    ${doctor_password}
    @{element_locators} =  Create List
    ...  (.//*[normalize-space(text()) and normalize-space(.)='Dashboard'])[1]/following::p[1]
    ...  (.//*[normalize-space(text()) and normalize-space(.)='Dashboard'])[1]/following::p[2]
    ...  (.//*[normalize-space(text()) and normalize-space(.)='Dashboard'])[1]/following::p[3]
    ...  (.//*[normalize-space(text()) and normalize-space(.)='Dashboard'])[1]/following::p[4]
    Dashboard Element UI Check    ${element_locators}


Scenario 1: Valid Login as Doctor
    [Documentation]    Test a successful login with valid credentials.
    [Tags]   common  doctor  login
    Log    Username: ${doctor_username}
    Log    Password: ${doctor_password}
    Maximize Browser Window
    Login Page UI Validation
    Common Login Process    ${doctor_username}    ${doctor_password}
    Dashboard Redirection    ${expected_dashboard_url}
    Verify Home Page Title
    Common Logout

Scenario 2: Invalid Password Login Test
    [Tags]    common    negative
    Maximize Browser Window
    @{roles} =    Create List    Doctor    Admin    Reception

    FOR    ${role}    IN    @{roles}
        ${username} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_username}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_username}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_username}
        ${invalid_password} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_invalid_password}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_invalid_password}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_invalid_password}
        Login Page UI Validation
        Common Login Process    ${username}    ${invalid_password}
        Wait Until Page Contains      ${expected_error_message}
#        Check Error Message    ${expected_error_message}
    END

Scenario 3: Invalid username Login Test
    [Tags]    common    negative
    Maximize Browser Window
    @{roles} =    Create List    Doctor    Admin    Reception

    FOR    ${role}    IN    @{roles}
        ${username} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_invalid_username}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_invalid_username}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable   ${reception_invalid_username}
        ${invalid_password} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable   ${doctor_password}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable      ${admin_password}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_password}
        Login Page UI Validation
        Common Login Process    ${username}    ${invalid_password}
        Wait Until Page Contains        ${expected_error_message}
#        Verify Error Message  ${expected_error_message}
    END

Scenario 4: Invalid username & Pasword Login Test
    [Tags]    common    negative
    Maximize Browser Window
    @{roles} =    Create List    Doctor    Admin    Reception

    FOR    ${role}    IN    @{roles}
        ${username} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_invalid_username}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_invalid_username}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable   ${reception_invalid_username}
        ${invalid_password} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable   ${doctor_invalid_password}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable      ${admin_invalid_password}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_ivalid_password}
        Login Page UI Validation
        Common Login Process    ${invalid_username}    ${invalid_password}
        Wait Until Page Contains        ${expected_error_message}
#        Verify Error Message  ${expected_error_message}
    END

Scenario 4: Empty Username Login Test
    [Tags]    common    negative
    Maximize Browser Window
    @{roles} =    Create List    Doctor    Admin    Reception

    FOR    ${role}    IN    @{roles}
        ${username} =    Set Variable    ${EMPTY}
        ${password} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_password}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_password}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_password}
        ${username_locator} =    Set Variable    id=email
        Login Page UI Validation
        Common Login Process    ${username}    ${password}
        Common Check Required Field Toggle    ${username_locator}    true
    END

Scenario 5: Empty Password Login Test
    [Tags]    common    negative
    Maximize Browser Window
    @{roles} =    Create List    Doctor    Admin    Reception

    FOR    ${role}    IN    @{roles}
        ${username} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable     ${doctor_username}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_username}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_username}
        ${password_locator} =    Set Variable     id=password
        ${password} =    Set Variable    ${EMPTY}
        Login Page UI Validation
        Common Login Process    ${username}    ${password}
        Common Check Required Field Toggle    ${password_locator}    true
    END

Scenario 6: Empty Username and Password Login Test
    [Tags]    common    negative
    Maximize Browser Window
    @{roles} =    Create List    Doctor    Admin    Reception

    FOR    ${role}    IN    @{roles}
        ${username} =    Set Variable    ${EMPTY}
        ${password} =    Set Variable    ${EMPTY}
        ${username_locator} =    Set Variable    id=email
        ${password_locator} =    Set Variable    id=password
        Login Page UI Validation
        Common Login Process    ${username}    ${password}
        Common Check Required Field Toggle   ${username_locator}  true
        Common Check Required Field Toggle   ${password_locator}   true
    END






Scenario 7:Test Remember Me Doctor
      [Tags]     Common   possitive
      ${username} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_username}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_username}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_username}
        ${invalid_password} =    Run Keyword If    '${role}' == 'Doctor'    Set Variable    ${doctor_invalid_password}
        ...    ELSE IF    '${role}' == 'Admin'    Set Variable    ${admin_invalid_password}
        ...    ELSE IF    '${role}' == 'Reception'    Set Variable    ${reception_invalid_password}
       Input Username and Password
      Click Remember Me Checkbox
      Submit Login Form
      Validate Remember Me Functionality
#    Common Remember Me Login    Doctor    ${Username}    ${Password}
#    Common Logout
#    Common Check Remember Me Functionality    ${DoctorUsername}    ${DoctorPassword}
#
#
#Scenario 8: Dashboard UI Check for Doctor
#    [Tags]   common  doctor  dashboard  ui
#    Login Page UI Validation
#    Common Login Process    ${doctor_username}    ${doctor_password}
#    Check Doctor Dashboard UI
#
#Scenario 9: Dashboard Counts Check for Doctor
#    [Tags]   common  doctor  dashboard  counts
#    Login Page UI Validation
#    Common Login Process    ${doctor_username}    ${doctor_password}
#    # Verify counts on the doctor's dashboard
#    Verify Doctor Dashboard Counts


#Scenario 10: Test Valid Login as Admin
#    [Tags]     common  admin  login
#    ${role}=    Set Variable    Admin  # Set the role to Doctor
#    Log    Username: ${admin_username}
#    Log    Password: ${admin_password}
#    Maximize Browser Window
#    Login Page UI Validation
#    Common Login Process    ${admin_username}    ${admin_password}
#    Dashboard Redirection    ${expected_url}
#    Verify Home Page Title
#    Common Logout
#
#
#Scenario 11: Test Valid Login as Reception
#    [Tags]      common  reception  login
#    ${role}=    Set Variable    Admin
#    Log    Username: ${reception_username}
#    Log    Password: ${reception_password}
#    Maximize Browser Window
#    Login Page UI Validation
#    Common Login Process    ${admin_username}    ${admin_password}
#    Dashboard Redirection    ${expected_url}
#    Verify Home Page Title
#    Common Logout
#
## Scenario 10: Remember Me admin
#Test Remember Me Admin
#    [Tags]    Admin
#    Common Remember Me Login    Admin     ${AdminUsername}    ${AdminPassword}
#    Common Logout
#    Common Check Remember Me Functionality    ${AdminUsername}    ${AdminPassword}
#
## Scenario 11: Remember Me Reception
#Test Remember Me Reception
#    [Tags]    Reception
#    Common Remember Me Login    Reception    ${ReceptionUsername}    ${ReceptionPassword}
#    Common Logout
#    Common Check Remember Me Functionality     ${ReceptionUsername}    ${ReceptionPassword}
#
Scenario 12:Test Add patient with valid data
    [Tags]    common  patient  positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirection to Appointment Page
    Navigate To Today Summary Page
    Search For Added Patient
    Go To Patient All Information Page
    Update Personal Information
    Verify Upload Button Is Visible



Scenario 13:Test Add Patient with Full Data
    [Tags]    common  patient  positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirection to Appointment Page


Scenario 14:Test Add Patient with Special Characters
    [Tags]    common  patient  positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page


Scenario 15:Test Add Patient with No Data
    [Tags]    common Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

Scenario 16: Test Add Patient with Duplicate Phone Number and Email
    [Tags]    common  patient  negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    # Ensure that you set the phone number and email to values that already exist in the system
    Set To Dictionary    ${patient_data}    phone_number    existing_phone_number    # Replace with an existing phone number
    Set To Dictionary    ${patient_data}    email    existing_email@example.com    # Replace with an existing email
    Common Add Patient    ${patient_data}
    # Check for an error message indicating the duplicate data
    Common Check Error Message    Patient with the same phone number or email already exists.    duplicate



# Scenario 14: Add patient with Different Gender
Test Add Patient with Different Gender
    [Tags]    common  patient  positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 15: Add patient with Long Address
Test Add Patient with Long Address
    [Tags]    common  patient  positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 16: Add patient with no Data
Test Add Patient with No Data
    [Tags]    common Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 17: Add Patient with Duplicate Phone Number and Email
Test Add Patient with Duplicate Phone Number and Email
    [Tags]    common  patient  negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    # Ensure that you set the phone number and email to values that already exist in the system
    Set To Dictionary    ${patient_data}    phone_number    existing_phone_number    # Replace with an existing phone number
    Set To Dictionary    ${patient_data}    email    existing_email@example.com    # Replace with an existing email
    Common Add Patient    ${patient_data}
    # Check for an error message indicating the duplicate data
    Common Check Error Message    Patient with the same phone number or email already exists.    duplicate

# Scenario 18: Add patient with Invalid Data
Test Add Patient with Invalid Data
    [Tags]    common Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 19: Add patient with Mandatory Field Only
Test Add Patient with Mandatory Field Only
    [Tags]    common Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 20: Add patient with Verify Field Validation
Test Add Patient with Verify Field Validation
    [Tags]    common  Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 21: Add patient with Missing Fields
Test Add Patient with Missing Fields
    [Tags]    common Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 22: Add patient with  Verify Mandatory Field Validation
Test Add Patient with Verify Mandatory Field Validation
    [Tags]    common Negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Add Patient    ${patient_data}
    # Check the UI state of the "Submit" button
    Check Submit Button UI State    id:submit_button    # Replace 'id:submit_button' with the actual identifier
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Scenario 23: Different Patient, Same Doctor, Same Time
Test Appointment Booking - Different Patient, Same Doctor, Same Time
    [Tags]    common    positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Select Different Patient and Same Doctor
    Common Choose Same Time Slot as Existing Appointment
    Common Attempt to Confirm Appointment
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

#Scenario 24: Test Book Appointment and Verify Redirection
Test Book Appointment and Verify Redirection
    [Tags]          appointment
    [Documentation]  Book an appointment and verify redirection based on the appointment date
    ${appointment_date}  Set Variable  2023-09-30  # Replace with your desired date
    Book Appointment  ${appointment_date}
    ${is_today}     Run Keyword And Return Status  Should Be Equal As Strings  ${appointment_date}  ${today_date}
    Run Keyword If  ${is_today}  Verify Redirect to View Appointment Page  ${appointment_date}
    ...              ELSE  Verify Redirect to All Appointments Page

Test Book Appointment for Today
    [Tags]          appointment
    [Documentation]  Book an appointment for today's date and verify redirection
    ${appointment_date}  Set Variable  ${today_date}
    Book Appointment  ${appointment_date}
    Verify Redirect to View Appointment Page  today
     update appointment
     Navigate To Today Summary Page
     updload photo,prescription,reports
     check calender



# Booking an appointment for a future date
Test Book Appointment for Future
    [Tags]          appointment
    [Documentation]  Book an appointment for a future date and verify redirection
    ${appointment_date}  Set Variable  2023-09-30  # Replace with your desired future date
    Book Appointment  ${appointment_date}
    Verify Redirect to View Appointment Page  future

# Viewing an appointment booked for today's date
Test View Today's Appointment
    [Tags]          appointment
    [Documentation]  View an appointment booked for today's date
    ${appointment_date}  Set Variable  ${today_date}
    Book Appointment  ${appointment_date}
    View Appointment
    Verify Redirect to All Appointments Page

# Viewing an appointment booked for a future date
Test View Future Appointment
    [Tags]          appointment
    [Documentation]  View an appointment booked for a future date
    ${appointment_date}  Set Variable  2023-09-30  # Replace with the date you used for booking
    Book Appointment  ${appointment_date}
    View Appointment
    Verify Redirect to All Appointments Page

# Scenario 18: Same Patient, Different Doctor, Same Time
Test Appointment Booking - Same Patient, Different Doctor, Same Time
    [Tags]    common    positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Log In as User
    Common Navigate to Appointment Booking Page
    Common Select Same Patient and Different Doctor
    Common Choose Same Time Slot as Existing Appointment
    Common Attempt to Confirm Appointment
    Common Verify Warning or Confirmation Prompt for Overlapping Appointment

# Scenario 19: Valid Data - Booking with Mandatory Fields Only
Test Appointment Booking with Valid Data - Mandatory Field Only
    [Tags]    common    positive
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Fill Mandatory Fields Only
    Common Attempt to Confirm Appointment
    Common Verify Confirmation Pop-up
    Common Click OK on Confirmation Pop-up
    Common Verify Redirect to Appointment Page

# Negative Scenarios
# Scenario 20: Same Patient, Same Doctor, Same Time
Test Appointment Booking - Same Patient, Same Doctor, Same Time
    [Tags]    common    negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Select Same Patient and Same Doctor
    Common Choose Same Time Slot as Existing Appointment
    Common Attempt to Confirm Appointment
    Common Verify Error Message for Existing Appointment

# Scenario 21: Invalid Data
Test Appointment Booking with Invalid Data
    [Tags]    common    negative
    ${patient_data}=    Create Dictionary    # Define your patient data her
    Common Navigate to Appointment Booking Page
    Common Fill Form with Invalid Data
    Common Attempt to Confirm Appointment
    Common Verify Error Message for Invalid Data

# Scenario 22: Field Validation Failure
Test Appointment Booking with Field Validation Failure
    [Tags]    common    negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Fill Form with Validation Failure Data
    Common Attempt to Confirm Appointment
    Common Verify Error Message for Field Validation Failure

# Scenario 23: No Data
Test Appointment Booking with No Data
    [Tags]    common    negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Leave Form Empty
    Common Attempt to Confirm Appointment
    Common Verify Error Message for Missing Data

# Scenario 24: Missing Fields
Test Appointment Booking with Missing Fields
    [Tags]    common    negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Fill Form with Missing Mandatory Fields
    Common Attempt to Confirm Appointment
    Common Verify Error Message for Missing Fields

# Scenario 25: Mandatory Field Validation Failure
Test Appointment Booking with Mandatory Field Validation Failure
    [Tags]    common    negative
    ${patient_data}=    Create Dictionary    # Define your patient data here
    Common Navigate to Appointment Booking Page
    Common Fill Form with Mandatory Field Validation Failure
    Common Attempt to Confirm Appointment
    Common Verify Error Message for Mandatory Field Validation Failure

# Scenario 26: Test Book Appointment for Today  date
Test Book Appointment for Today
    [Tags]          appointment
    [Documentation]  Book an appointment for today's date and verify redirection
    ${appointment_date}  Set Variable  ${today_date}
    Book Appointment  ${appointment_date}
    Verify Redirect to View Appointment Page  today

# Scenario 26:  Test Book Appointment for Future date
Test Book Appointment for Future
    [Tags]          appointment
    [Documentation]  Book an appointment for a future date and verify redirection
    ${appointment_date}  Set Variable  2023-09-30  # Replace with your desired future date
    Book Appointment  ${appointment_date}
    Verify Redirect to View Appointment Page  future

#Scanario 27:Viewing an appointment booked for today's date
Test View Today's Appointment
    [Tags]          appointment
    [Documentation]  View an appointment booked for today's date
    ${appointment_date}  Set Variable  ${today_date}
    Book Appointment  ${appointment_date}
    View Appointment
    Verify Redirect to All Appointments Page

#Scanario 28: Viewing an appointment booked for a future date
Test View Future Appointment
    [Tags]          appointment
    [Documentation]  View an appointment booked for a future date
    ${appointment_date}  Set Variable  2023-09-30  # Replace with the date you used for booking
    Book Appointment  ${appointment_date}
    Verify Redirect to All Appointments Page

#empty login
#*** Settings ***
#Library    SeleniumLibrary
#Resource  ../resources/common_keywords.robot
#
#*** Variables ***
#${BROWSER}    Chrome
#${SELSPEED}   0.0s
#${BaseURL}    https://procliniq.in
#
#*** Test Cases ***
## Scenario 1: Login with Empty Username
#Test Login with Empty Username
#    [Tags]   login  negative
#    Common Handle Empty Login    ${EMPTY}    ${ValidPassword}
#    Common Check Required Field Toggle    ${UsernameField}
#
## Scenario 2: Login with Empty Password
#Test Login with Empty Password
#    [Tags]   login  negative
#    Common Handle Empty Login    ${ValidUsername}    ${EMPTY}
#    Common Check Required Field Toggle    ${PasswordField}
#
## Scenario 3: Login with Both Username and Password Empty
#Test Login with Both Username and Password Empty
#    [Tags]   login  negative
#    Common Handle Empty Login    ${EMPTY}    ${EMPTY}
#    Common Check Required Field Toggle    ${UsernameField}
#    Common Check Required Field Toggle    ${PasswordField}
#
#*** Keywords ***
#Common Handle Empty Login
#    [Arguments]    ${username}    ${password}
#    [Documentation]    Handles login with empty username and password.
#    Input Text    ${UsernameField}    ${username}
#    Input Text    ${PasswordField}    ${password}
#    Click Element    ${LoginButton}
#
#Common Check Required Field Toggle
#    [Arguments]    ${field_locator}
#    [Documentation]    Verifies that the required field toggle is displayed.
#    Element Should Be Visible    ${field_locator}
#


#empty login
## Scenario 6: Empty Login as Doctor
#Test Empty Login as Doctor
#    [Tags]    common  negative
#    Common Handle Empty Login    ${Doctor.username}    ${Doctor.password}
#    Common Check Error Message    Username and password are required.    empty
#
## Scenario 7: Empty Login as Admin
#Test Empty Login as Admin
#    [Tags]    common  negative
#    Common Handle Empty Login    ${Admin.username}    ${Admin.password}
#    Common Check Error Message    Username and password are required.    empty
#
## Scenario 8: Empty Login as Reception
#Test Empty Login as Reception
#    [Tags]    common  negative
#    Common Handle Empty Login    ${Reception.username}
#    Common Check Error Message    Username and password are required.    empty

# Scenario 9: Remember Me Admin

















#*** Test Cases ***
#Run All Test Cases
#    [Tags]   common
#    Test Valid Login as Doctor
#    Test Valid Login as Admin
#    Test Valid Login as Reception
#    Test Add Patient
#    Test Today Summary Page Access
#    Test Search Patient
#    Test Update Patient
#    Test Today Summary Page Access
#    Test Appointment Booking
#    Test Today Summary Page Access
#    Test Update Appointment
#    Test Calendar Check
#    Test Search Patient Again
#    Test Report and Prescription Upload
#
#Test Valid Login as Doctor
#    [Tags]   common  doctor  login
#    Set Credentials    Doctor
#    Log    Username: ${Doctor['username']}
#    Log    Password: ${Doctor['password']}
#    Common Check Doctor Dashboard
#    Common Logout
#
#Test Valid Login as Admin
#    [Tags]     common  admin  login
#    Set Credentials    Admin
#    Log    Username: ${Admin['username']}
#    Log    Password: ${Admin['password']}
#    Common Check Doctor Dashboard
#    Common Logout
#
#Test Valid Login as Reception
#    [Tags]      common  reception  login
#    Set Credentials    Reception
#    Log    Username: ${Reception['username']}
#    Log    Password: ${Reception['password']}
#    Common Check Reception Dashboard
#    Common Logout
#
#Test Add Patient
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Today Summary Page Access
#    [Tags]    common
#    Common Today Summary Page Access
#
#Test Search Patient
#    [Tags]    common
#    Common Search Patient
#
#Test Update Patient
#    [Tags]    common
#    Common Update Patient
#
#Test Appointment Booking
#    [Tags]    common
#    ${appointment_details}=    Create Dictionary    # Define your appointment data here
#    Common Appointment_Booking  ${appointment_details}
#
#Test Update Appointment
#    [Tags]    common
#    Common Update Appointment
#
#Test Calendar Check
#    [Tags]    common
#    Common Calendar Check
#
#Test Search Patient Again
#    [Tags]    common
#    Common Search Patient Again
#
#Test Report and Prescription Upload
#    [Tags]    common
#    Common Report and Prescription Upload

#*** Settings ***
#Library  SeleniumLibrary
#Resource  ../resources/common_keywords.robot  # Use ../ to navigate up to the 'resources' directory
#
#
#Adding a Patient and Redirecting to Appointment Booking Page
#    [Tags]    common
#    Add Patient with Valid Data
#    Verify Redirect to Appointment Page
#
#Test Add Patient with Valid Data
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Add Patient with No Data
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Add Patient with Invalid Data
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Add Patient with Verify Field Validation
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Add Patient with Missing Fields
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Add Patient with Mandatory Field Only
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Add Patient with Verify Mandatory Field Validation
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Add Patient    ${patient_data}
#
#Test Appointment Booking with Valid Data
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Appointment_Booking  ${appointment_details}
#
#Test Appoinment Booking with No Data
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Appointment_Booking   ${appointment_details}
#
#Test Appointment Booking with Invalid Data
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Appointment_Booking  ${appointment_details}
#
#Test Appointment Booking with Verify Field Validation
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Appointment_Booking   ${appointment_details}
#
#Test Appointment Booking with Missing Fields
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Appointment_Booking   ${appointment_details}
#
#Test Appointment Booking with Mandatory Field Only
#    [Tags]    common
#    ${patient_data}=    Create Dictionary    # Define your patient data here
#    Common Appointment_Booking   ${appointment_details}


