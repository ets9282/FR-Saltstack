/*
 * Copyright 2015-2017 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */

/*global addPolicy, request, openidm */

addPolicy({
    "policyId" : "is-new",
    "policyExec" : "isNew",
    "policyRequirements" : ["PASSWORD_HISTORY"]
});

function isNew(fullObject, value, params, property) {
    var historyLength, fieldHistory, currentObject, lastFieldValues, i;
    // Don't enforce this policy if the resource ends with "/*", which indicates that this is a create with a 
    // server-supplied id
    if (!request.resourcePath || request.resourcePath.match('/\\*$')) {
        return [];
    }

    // Read the resource
    currentObject = openidm.read(request.resourcePath);
//	logger.info("PWdHistory: fullObject->"+fullObject);
//	logger.info("PWdHistory: value->"+value);
	logger.info("PWdHistory: params->"+params);
	logger.info("PWdHistory: property->"+property);
	logger.info("PWdHistory: currentObject->"+currentObject);

    // Don't enforce this policy if the resource being evaluated wasn't found. Happens in the case of a create with a 
    // client-supplied id.
    if (currentObject === null) {
        return [];
    }
  // Decrypt the "fieldHistory" field.
    fieldHistory = currentObject.fieldHistory;
	if(typeof currentObject.fieldHistory==="undefined" &&  (fieldHistory[property] === undefined || fieldHistory[property] === null)){
    
	   logger.info("PWdHistory: currentObject.fieldHistory ->"+currentObject.fieldHistory);
	return [];
}  
    // Don't enforce this policy if there is no history object available
	
  
    // Get the current field value
    if (currentObject[property] !== undefined && currentObject[property] !== null &&
            openidm.isEncrypted(currentObject[property])) {
        currentObject[property] = openidm.decrypt(currentObject[property]);
    }
//	logger.info("PWdHistory: currentObject[property]->"+ currentObject[property]);
    // Don't enforce this policy if the password hasn't changed
    if (value=== undefined ) {
        return [];
    }
	
	if(currentObject[property] === value && property ==="password" ) {
		return [{"policyRequirement": "PASSWORD_HISTORY"}];
	}

    // Get the last field values
    lastFieldValues = fieldHistory[property];
	logger.info("PWdHistory: lastFieldValues->"+fieldHistory[property]);
    if (params.historyLength !== undefined) {
        historyLength = params.historyLength;
    } else {
        historyLength = lastFieldValues.length;
    }

    numOfFields = lastFieldValues.length;
	logger.info("PWdHistory: numOfFields->"+numOfFields);
    // Check if the current value matches any previous values
    for(i = numOfFields - 1; i >= (numOfFields - historyLength) && i >= 0; i--) {
        if ((openidm.isHashed(lastFieldValues[i]) && openidm.matches(value, lastFieldValues[i]))
                || (lastFieldValues[i] === value)) {
            return [{"policyRequirement": "PASSWORD_HISTORY"}];
        }
    }
    
    return [];

}
