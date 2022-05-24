*** Settings ***
Variables   common.py

Library     neofs_verbs.py
Library     container.py
Library     storage_group.py
Library     utility_keywords.py

Resource    setup_teardown.robot
Resource    payment_operations.robot
Resource    storage_group.robot

*** Variables ***
@{UNEXIST_OID} =        B2DKvkHnLnPvapbDgfpU1oVUPuXQo5LTfKVxmNDZXQff

*** Test cases ***
NeoFS Simple Storagegroup
    [Documentation]     Testcase to validate NeoFS operations with Storagegroup.
    [Tags]              Object
    [Timeout]           20 min

    [Setup]             Setup

    ${WALLET}   ${_}     ${_} =   Prepare Wallet And Deposit
    ${CID} =            Create container    ${WALLET}

    ${FILE_S}    ${_} =    Generate file            ${SIMPLE_OBJ_SIZE}

    ${OID_1} =          Put object    ${WALLET}    ${FILE_S}    ${CID}
    ${OID_2} =          Put object    ${WALLET}    ${FILE_S}    ${CID}

    @{ONE_OBJECT} =     Create List    ${OID_1}
    @{TWO_OBJECTS} =    Create List    ${OID_1}    ${OID_2}

                        Run Storage Group Operations And Expect Success
                        ...     ${WALLET}   ${CID}      ${ONE_OBJECT}   Simple

                        Run Storage Group Operations And Expect Success
                        ...     ${WALLET}   ${CID}      ${TWO_OBJECTS}   Simple

                        Run Keyword And Expect Error    *
                        ...  Put Storagegroup    ${WALLET}    ${CID}    ${UNEXIST_OID}
                        Run Keyword And Expect Error    *
                        ...  Delete Storagegroup    ${WALLET}    ${CID}    ${UNEXIST_OID}

    [Teardown]          Teardown    object_storage_group_simple