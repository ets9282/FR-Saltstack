#!/bin/bash

#Install OpenAM...

FORGEROCK_HOME={{ pillar['forgerock']['forgerock-home']}}
INSTALLER_LOC={{ pillar['forgerock']['installer-location'] }}
TOMCAT_VERSION={{ pillar['tomcat']['version'] }}
TOMCAT_HOME={{ pillar['tomcat']['catalina_base'] }}
OPENAM_WAR=${INSTALLER_LOC}/{{ pillar['openam']['war'] }}
THIS=$(pwd)




validate() {
    if [[ ! -d ${FORGEROCK_HOME} ]]; then
        echo "Forgerock home doesnt exist: ${FORGEROCK_HOME}"
        exit 1
    fi

    if [[ ! -d ${TOMCAT_HOME} ]]; then
        echo "Tomcat doesnt exist: ${TOMCAT_HOME}"
        exit 1
    fi

    if [ -d "${TOMCAT_HOME}/webapps/openam}" ]; then
	    echo "OpenAM already exists inside ${TOMCAT_HOME}. Exiting."

	    echo
	    echo "changed=no comment='OpenAM Already deployed in target location'"
	    exit 0
    fi

}

validate

cp ${OPENAM_WAR} ${TOMCAT_HOME}/webapps/openam.war

cd ${THIS}

echo  # an empty line here so the next line will be the last.
echo "changed=yes comment='OpenAM installation complete.'"
