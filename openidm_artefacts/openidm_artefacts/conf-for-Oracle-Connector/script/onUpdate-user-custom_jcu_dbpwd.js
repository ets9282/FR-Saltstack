/*
 * Copyright 2015-2017 ForgeRock AS. All Rights Reserved
 *
 * Use of this code requires a commercial software license with ForgeRock AS.
 * or with one of its affiliates. All use shall be exclusively subject
 * to such license between the licensee and ForgeRock AS.
 */


(function () {
    exports.syncPasswordtoDB= function (object, request) {

if 	(object.userName !== undefined || object.userName !== null) { 
logger.info(" Processing syncPasswordtoDB for -> "+ object.userName);
}


var queryParam={
"_action" : 'script',
"scriptId" : 'UpdatePassword'
};


var updatedParam = {
        
        "password" : object.password,
        "uid" : object.userName
    };

var result=openidm.action("system/pwddb", "script", updatedParam,{"scriptId" : 'UpdatePassword'});
  logger.info("system pwddb rest call response->"+result);     
    };
}());
