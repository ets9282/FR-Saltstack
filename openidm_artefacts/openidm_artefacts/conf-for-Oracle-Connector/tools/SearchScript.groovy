/*
 * Copyright 2015-2018 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */
package org.forgerock.openicf.connectors.pwddb

import java.sql.Connection

import org.forgerock.openicf.connectors.groovy.MapFilterVisitor
import org.forgerock.openicf.connectors.groovy.OperationType
import org.forgerock.openicf.connectors.scriptedsql.ScriptedSQLConfiguration
import org.identityconnectors.common.logging.Log
import org.identityconnectors.framework.common.exceptions.ConnectorException
import org.identityconnectors.framework.common.objects.AttributeBuilder
import org.identityconnectors.framework.common.objects.ObjectClass
import org.identityconnectors.framework.common.objects.OperationOptions
import org.identityconnectors.framework.common.objects.SearchResult
import org.identityconnectors.framework.common.objects.filter.Filter

import groovy.sql.Sql

/**
 * Built-in accessible objects
 **/

// OperationType is SEARCH for this script
def operation = operation as OperationType

// The configuration class created specifically for this connector
def configuration = configuration as ScriptedSQLConfiguration

// Default logging facility
def log = log as Log

// The objectClass of the object to be searched, e.g. ACCOUNT or GROUP
def objectClass = objectClass as ObjectClass

// The search filter for this operation
def filter = filter as Filter

// Additional options for this operation
def options = options as OperationOptions


def connection = connection as Connection
def ORG = new ObjectClass("organization")


log.info("Entering " + operation + " Script")

def sql = new Sql(connection)
def where = " WHERE 1=1 "
def whereParams = []

// Set where and whereParams if they have been passed in the request for paging
if (options.pagedResultsCookie != null) {
    def cookieProps = options.pagedResultsCookie.split(",")
    if (cookieProps.size() != 2) {
        throw new ConnectorException("Expecting pagedResultsCookie to contain timestamp and id.")
    }
    // The timestamp and id are for this example only.
    // The user can use their own properties to sort on.
    // For paging it is important that the properties that you use must identify
    // a distinct set of pages for each iteration of the
    // pagedResultsCookie, which can be decided by last record of the previous set.
    where = " WHERE timestamp >= ? AND id > ? "
    whereParams = [cookieProps[0], cookieProps[1].toInteger()]
}

// Determine what properties will be used to sort the query
def orderBy = []
if (options.sortKeys != null && options.sortKeys.size() > 0) {
    options.sortKeys.each {
        def key = it.toString()
        if (key.substring(0, 1) == "+") {
            orderBy.add(key.substring(1, key.size()) + " ASC")
        } else {
            orderBy.add(key.substring(1, key.size()) + " DESC")
        }
    }
    orderBy = " ORDER BY " + orderBy.join(",")
} else {
    orderBy = ""
}

def limit = ""
if (options.pageSize != null) {
    limit = " LIMIT " + options.pageSize.toString()
}

// keep track of lastTimestamp and lastId so we can
// use it for the next request to do paging
def lastTimestamp
def lastId

if (filter != null) {

    def query = filter.accept(MapFilterVisitor.INSTANCE, null)
    //Need to handle the __UID__ and __NAME__ in queries - this map has entries for each objectType,
    //and is used to translate fields that might exist in the query object from the ICF identifier
    //back to the real property name.
    def fieldMap = [
           
            "__ACCOUNT__" : [
                    "ACCOUNTID" : "uid",
                    "LASTCHANGED": "LASTCHANGED"
            ]
    ]

    

    where = where + " AND " + queryParser(query)
    log.ok("Search WHERE clause is: " + where)
}
def resultCount = 0
switch (objectClass) {
    case ObjectClass.ACCOUNT:
        

        def handleCollectedData = {
            if (dataCollector.uid != "") {
                handler {
                    uid dataCollector.ACCOUNTID
                    attribute 'uid', dataCollector.ACCOUNTID
                    
                }

            }
        }

        def statement = """
            SELECT
            ACCOUNTID,
            FIRSTNAME,
            LASTNAME,
            LASTCHANGED,
	    LASTCHANGEDBY,
	    SEQNO          
            FROM
            PWD_ACCOUNT
        """
        sql.eachRow(statement, whereParams, { row ->
            if (dataCollector.ACCOUNTID!= row.ACCOUNTID) {
                // new user row, process what we've collected

                handleCollectedData()

                dataCollector = [
                        uid         : row.ACCOUNTID,
                        firstname   : row.FIRSTNAME,
                        lastname    : row.LASTNAME,
                        lastchanged : row.LASTCHANGED,
			lastchangedby: row.LASTCHANGEDBY,
			seqno     : row.SEQNO   
                        
                ]
            }

            lastTimestamp = row.timestamp
            lastId = row.id
            resultCount++
        })

        handleCollectedData()

        break
    default:
        throw new UnsupportedOperationException(operation.name() + " operation of type:" +
                objectClass.objectClassValue + " is not supported.")
}

// If paging is not wanted just return the default SearchResult object
if (orderBy.toString().isEmpty() || limit.toString().isEmpty() || resultCount < options.pageSize) {
    return new SearchResult()
}

return new SearchResult(lastTimestamp.toString() + "," + lastId.toString(), -1)
