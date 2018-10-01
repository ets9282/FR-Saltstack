/*
 * Copyright 2010-2018 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */


import java.sql.Connection

import org.forgerock.openicf.connectors.groovy.OperationType
import org.identityconnectors.common.logging.Log
import org.identityconnectors.framework.common.exceptions.ConnectorException

import groovy.sql.Sql

// Parameters:
// The connector sends us the following:
// connection : SQL connection
// action: String correponding to the action ("RUNSCRIPTONCONNECTOR" here)
// log: a handler to the Log facility
// options: a handler to the OperationOptions Map
//
// Arguments can be passed to the script in the REST call, e.g.:
//
// curl -k --header "X-OpenIDM-Username: openidm-admin" \
// --header "X-OpenIDM-Password: openidm-admin" \
// --header "Content-Type: application/json" \
// --request POST "https://localhost:8443/openidm/system/hrdb?_action=script&scriptId=ResetDatabase" \
// -d "{\"arg1\":\"foo\",\"arg2\":\"bar\"}"
//
// These arguments can be accessed here by name, e.g.
//
// def firstArg = arg1 as String;
//
// Note that these can be complex types; Arguments are passed in as Object type.

def operation = operation as OperationType
def connection = connection as Connection
def sql = new Sql(connection);
def log = log as Log

log.info("Entering " + operation + " Script");


def userPwd=password as String;
def uid=uid as String
log.info("Entering " + operation + " Script & firstArg->" + uid);

def params = [uid, userPwd]
def sqlcall  = '{call PWDRESOURCE_DEV.passwords.setpassword(?, ?)}'
def rowsChanged =sql.call(sqlcall , params);

//def acntID = acntID as String
//def seqno  =  seqno as String
//def lastchanged  = lastchanged as String
// do select with provided
sql.eachRow("select accountID,FIRSTNAME,LASTNAME ,LASTCHANGED ,SEQNO, lastchangedby from PWD_ACCOUNT where accountID = ?", [uid])
        { resultSet ->           
              log.info(" Password updated successfully for user: "+ resultSet.accountID+ " , FIRSTNAME: " + resultSet.FIRSTNAME + " , LASTNAME : " + resultSet.LASTNAME +
			 " , LASTCHANGED: " + resultSet.LASTCHANGED + " ,SEQNO: " + resultSet.SEQNO);
          }


log.info(" Number of rows updated in database "+ rowsChanged );

return "Nnumber of rows updated :"+ rowsChanged  

