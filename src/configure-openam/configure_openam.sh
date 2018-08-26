#!/bin/bash
set -e
#Configure OpenAM..


validate() {

    if [[ -z ${CONFIG_TOOL_JAR} ]]; then
        echo "CONFIG_TOOL_JAR is not defined"
        echo
        echo "changed=no comment='CONFIG_TOOL_JAR is not defined'"
        exit 1
    fi

    if [[ -z ${SCRIPTS_LOCATION} ]]; then
        echo "SCRIPTS_LOCATION is not defined"
        echo
        echo "changed=no comment='SCRIPTS_LOCATION is not defined'"
        exit 1
    fi

    if [[ -z ${FORGEROCK_HOME} ]]; then
        echo "FORGEROCK_HOME is not defined"
        echo
        echo "changed=no comment='FORGEROCK_HOME is not defined'"
        exit 1
    fi

    if [[ -z ${JAVA_HOME} ]]; then
        echo "JAVA_HOME is not defined"
        echo
        echo "changed=no comment='JAVA_HOME is not defined'"
        exit 1
    fi

    if [[ ! -d ${FORGEROCK_HOME} ]]; then
        echo
        echo "Forgerock home doesnt exist: ${FORGEROCK_HOME}"
        exit 1
    fi

    if [ -f "${FORGEROCK_HOME}/openam/boot.json" ]; then
	    echo "OpenAM configuration already exists inside ${FORGEROCK_HOME}/openam"
	    echo
	    echo "changed=no comment='OpenAM already configured'"
	    exit 0
    fi

}

validate

export PATH=${PATH}:${JAVA_HOME}/bin

java -jar ${FORGEROCK_HOME}/openam_tools/configurator/${CONFIG_TOOL_JAR} --acceptLicense --file ${SCRIPTS_LOCATION}/openam-config.properties


echo
echo "changed=yes comment='OpenAM configured successfully'"
exit 0