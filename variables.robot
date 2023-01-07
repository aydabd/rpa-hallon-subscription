*** Settings ***
Documentation                       Neccessary variables for this robot

*** Variables ***


${HALLON_FIRST_PAGE}                https://www.hallon.se/mobilabonnemang
${CLASS_JS_AVAILABLE_NUMBERS}       //select[@class="js-available-numbers"]
${BUTTON_ACCEPT_COOKIES}            //button[@id="onetrust-accept-btn-handler"]
${BUTTON_ORDER_NOW}                 //*[@title="Beställ nu"]
${DESIRED_NUMBERS_PATTERN}          *67776*
${TIMEOUT}                          2h
${CHECK_INTERVAL}                   1s
