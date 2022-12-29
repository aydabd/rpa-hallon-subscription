*** Settings ***
Documentation       Order Hallon sim card with desired number

Library             RPA.Browser.Selenium
Library             Collections
Library             RPA.Notifier
Library             RPA.Dialogs
Library             OperatingSystem

Suite Setup         Setup ordering hallon sim card
Suite Teardown      Teardown


*** Variables ***
${HALLON_FIRST_PAGE}                https://www.hallon.se/mobilabonnemang
${CLASS_JS_AVAILABLE_NUMBERS}       //select[@class="js-available-numbers"]
${BUTTON_ACCEPT_COOKIES}            //button[@id="onetrust-accept-btn-handler"]
${BUTTON_ORDER_NOW}                 //*[@title="Beställ nu"]
${DESIRED_NUMBERS_PATTERN}          *67776*
${TIMEOUT}                          3600 min
${CHECK_INTERVAL}                   1 s


*** Tasks ***
Order abbonemang
    Wait until find number


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
    ${status}=    Run Keyword And Return Status    Select Checkbox    id:toc
    Log    Checkbox checked: ${status}
    RETURN    ${status}

Submit buy
    Submit Form    id:buyButton

Verify numbers
    [Arguments]    ${numbers}    ${expected_numbers}=${DESIRED_NUMBERS_PATTERN}
    Log    Searching numbers: ${numbers}    level=DEBUG    console=True
    Should Contain Match    ${numbers}    ${expected_numbers}

Reload page and find number
    Reload Page
    ${numbers}=    Get all numbers
    Fill personal identity number and mail
    Verify numbers    ${numbers}

Wait until find number
    [Documentation]    Wait until find the desired number.
    [Arguments]    ${timeout}=${TIMEOUT}    ${check_interval}=${CHECK_INTERVAL}
    Wait Until Keyword Succeeds    ${timeout}    ${check_interval}    Reload page and find number
    Log    Found desired pattern for number: ${DESIRED_NUMBERS_PATTERN} and ready to submit the form    console=True
    Sleep    20m    Wait 20 minutes to submit the form manually!
