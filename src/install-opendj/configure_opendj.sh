#!/bin/bash
set -e

# Configure OpenDJ

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


opendj_bin=${FORGEROCK_HOME}/opendj/bin


echo "Configure password policy and changelog"

${opendj_bin}/dsconfig \
 create-replication-server \
 --hostname localhost \
 --port 4444 \
 --bindDN "cn=Directory Manager" \
 --bindPassword ${PASSWD} \
 --provider-name "Multimaster Synchronization" \
 --set replication-port:8989 \
 --set replication-server-id:2 \
 --trustAll \
 --no-prompt

${opendj_bin}/dsconfig \
  create-replication-domain \
  --hostname localhost \
  --port 4444 \
  --bindDN "cn=Directory Manager" \
  --bindPassword ${PASSWD} \
  --provider-name "Multimaster Synchronization" \
  --domain-name "jcu.edu.au" \
  --set base-dn:"${BASE_DN}" \
  --set replication-server:localhost:8989 \
  --set server-id:3 \
  --trustAll \
  --no-prompt

echo "Changelog enabled"


${opendj_bin}/dsconfig \
    set-password-policy-prop \
    --policy-name "Default Password Policy" \
    --port 4444 \
    --hostname localhost \
    --bindDN "cn=Directory Manager" \
    --bindPassword ${PASSWD} \
    --set last-login-time-attribute:ds-pwp-last-login-time \
    --set last-login-time-format:"yyyyMMddHHmmss'Z'" \
    --trustAll \
    --no-prompt

echo "Password policy configured"


##OpenAM specific configuration##
echo "Adding OpenAM Admin user"
${opendj_bin}/ldapmodify \
 --hostname localhost \
 --port 1389 \
 --bindDN "cn=Directory Manager" \
 --bindPassword ${PASSWD} \
 --filename ${LDIF_LOCATION}/openam-ds-admin-account.ldif

echo "Adding global ACL that lets OpenAM Admin account modify the directory schema"
${opendj_bin}/dsconfig set-access-control-handler-prop \
 --hostname localhost \
 --port 4444 \
 --bindDN "cn=Directory Manager" \
 --bindPassword ${PASSWD} \
 --no-prompt \
 --trustAll \
 --add \
  'global-aci:(target="ldap:///cn=schema")(targetattr="attributeTypes||objectClasses")
    (version 3.0; acl "Modify schema"; allow (write)
    userdn="ldap:///{{pillar['opendj']['config']['priv_user_dn']}}";)'

echo "Listing global ACIs"
${opendj_bin}/dsconfig get-access-control-handler-prop \
  --port 4444 \
  --hostname localhost \
  --trustAll \
  --no-prompt \
  --bindDN "cn=Directory Manager" \
  --bindPassword ${PASSWD} \
  --property global-aci

echo "Adding ACIs for admin access"
${opendj_bin}/ldapmodify \
  --hostname localhost \
  --port 1389 \
  --bindDN "cn=Directory Manager" \
  --bindPassword ${PASSWD} \
  --filename ${LDIF_LOCATION}/add-acis-for-openam-admin-access.ldif


echo
echo "changed=yes comment='opendj configured successfully.'"
exit 0