*** Settings ***
Documentation       Order Hallon sim card with desired number

Resource            keywords.robot

Suite Setup         Setup ordering hallon sim card
Suite Teardown      Teardown


*** Tasks ***
Order default subscription 4GB
    Wait until find number
