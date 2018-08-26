#!/bin/bash
set -e

# Install OpenDJ

validate() {
    if [[ -z ${JAVA_HOME} ]]; then
        echo "JAVA_HOME is not defined"
        echo
        echo "changed=no comment='JAVA_HOME is not defined'"
        exit 1
    fi

    if [[ -z ${OPENDJ_JAVA_HOME} ]]; then
        echo "OPENDJ_JAVA_HOME is not defined"
        echo
        echo "changed=no comment='OPENDJ_JAVA_HOME is not defined'"
        exit 1
    fi

    if [[ -z ${FORGEROCK_HOME} ]]; then
        echo "FORGEROCK_HOME is not defined"
        echo
        echo "changed=no comment='FORGEROCK_HOME is not defined'"
        exit 1
    fi

     if [[ -z ${PASSWD} ]]; then
        echo "PASSWD is not defined"
        echo
        echo "changed=no comment='PASSWD is not defined'"
        exit 1
    fi

    if [[ -z ${BASE_DN} ]]; then
        echo "BASE_DN is not defined"
        echo
        echo "changed=no comment='BASE_DN is not defined'"
        exit 1
    fi

    if [[ ! -d ${FORGEROCK_HOME} ]]; then
        echo "Forgerock home doesnt exist: ${FORGEROCK_HOME}"
        echo
        echo "changed=no comment='Forgerock home doesnt exist: ${FORGEROCK_HOME}'"
        exit 1
    fi

    if [[ ! -d ${FORGEROCK_HOME}/opendj ]]; then
        echo "OpenDJ doesnt exist: ${FORGEROCK_HOME}/opendj"
        echo
        echo "changed=no comment='OpenDJ doesnt exist: ${FORGEROCK_HOME}/opendj'"
        exit 1
    fi
}

validate


${FORGEROCK_HOME}/opendj/setup -p 1389 --ldapsPort 1636 --enableStartTLS  \
  --adminConnectorPort 4444 \
  --baseDN ${BASE_DN} -h localhost --rootUserPassword ${PASSWD} \
  --addBaseEntry \
  --acceptLicense


echo "Done! Post install pending."
echo
echo "changed=yes comment='opendj installed successfully.'"
exit 0