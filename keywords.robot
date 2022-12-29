*** Settings ***
Documentation       Keywords as helper methods for ordering subscription

Library             RPA.Browser.Selenium
Library             Collections
Library             RPA.Notifier
Library             RPA.Dialogs
Library             OperatingSystem

Resource            variables.robot


*** Keywords ***
Open hallon first page
    Open Chrome Browser    ${HALLON_FIRST_PAGE}

Accept all cookies
    Click Element When Visible    ${BUTTON_ACCEPT_COOKIES}    # Godkänn alla cookies

Order now
    Click Element When Visible    ${BUTTON_ORDER_NOW}

Setup ordering hallon sim card
    Open hallon first page
    Accept all cookies
    Order now

Teardown
    Delete All Cookies
    Close All Browsers

Get all numbers
    Wait Until Element Is Visible    ${CLASS_JS_AVAILABLE_NUMBERS}
    ${numbers}=    Get List Items    ${CLASS_JS_AVAILABLE_NUMBERS}
    RETURN    ${numbers}

Fill personal identity number and mail
    ${EMAIL_ADDRESS}=                Get Environment Variable        EMAIL_ADDRESS             # xxxx@xxx.com
    ${SOCIAL_SECURITY_NUMBER}=       Get Environment Variable        SOCIAL_SECURITY_NUMBER    # yyyymmdd-xxxx
    IF    ${EMAIL_ADDRESS}
        Input Text When Element Is Visible    id:checkout__email    ${EMAIL_ADDRESS}
    END
    IF    ${SOCIAL_SECURITY_NUMBER}
        Input Text When Element Is Visible    id:checkout__personnummer    ${SOCIAL_SECURITY_NUMBER}
    END
    
Checkbox terms and condition
    ${status}=    Run Keyword And Return Status    Select Checkbox    id:toc    # terms and condition checkbox
    Log    Checkbox checked: ${status}
    RETURN    ${status}

Submit buy
    Submit Form    id:buyButton

Verify numbers
    [Arguments]    ${numbers}    ${expected_numbers}=${DESIRED_NUMBERS_PATTERN}
    Log    Searching numbers: ${numbers}    level=DEBUG
    Should Contain Match    ${numbers}    ${expected_numbers}

Reload page and find number
    Reload Page
    ${numbers}=    Get all numbers
    Verify numbers    ${numbers}

Wait until find number
    [Documentation]    Wait until find the desired number.
    [Arguments]    ${timeout}=${TIMEOUT}    ${check_interval}=${CHECK_INTERVAL}
    Wait Until Keyword Succeeds    ${timeout}    ${check_interval}    Reload page and find number
    Log    Found desired pattern for number: ${DESIRED_NUMBERS_PATTERN} and ready to submit the form    console=True
    Fill personal identity number and mail
    Sleep    20m    Wait 20 minutes to submit the form manually!
