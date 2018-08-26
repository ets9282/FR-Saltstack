#!/bin/bash
set -e
#Configure ssoadm..


validate() {

    if [[ -z ${FORGEROCK_HOME} ]]; then
        echo "FORGEROCK_HOME is not defined"
        echo
        echo "changed=no comment='FORGEROCK_HOME is not defined'"
        exit 1
    fi

    if [[ -z ${AM_ADMIN_PW} ]]; then
        echo "AM_ADMIN_PW is not defined"
        echo
        echo "changed=no comment='AM_ADMIN_PW is not defined'"
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

    if [[ ! -f ${FORGEROCK_HOME}/openam/boot.json ]]; then
        echo
        echo "OpenAM configuration doesnt exist: ${FORGEROCK_HOME}/openam/boot.json"
        exit 1
    fi

}

validate

export PATH=${PATH}:${JAVA_HOME}/bin


cd ${FORGEROCK_HOME}/openam_tools/ssoadm

./setup --acceptLicense --path ${FORGEROCK_HOME}/openam

cd ${FORGEROCK_HOME}/openam_tools/ssoadm/openam/bin

[ -f passwd ] && rm -f passwd
echo ${AM_ADMIN_PW} > passwd
chmod 400 passwd

echo
echo "changed=yes comment='OpenAM configured successfully'"
exit 0
