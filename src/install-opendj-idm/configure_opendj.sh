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


echo "Create the matching rules required to set up indexes for the default IDM data"

${opendj_bin}/dsconfig \
 create-schema-provider \
 --hostname ${HOSTNAME} \
 --port 34444 \
 --bindDN "cn=Directory Manager" \
 --bindPassword ${PASSWD} \
 --provider-name "IDM managed/user Json Schema" \
 --type json-query-equality-matching-rule \
 --set enabled:true \
 --set case-sensitive-strings:false \
 --set ignore-white-space:true \
 --set matching-rule-name:caseIgnoreJsonQueryMatchManagedUser \
 --set matching-rule-oid:1.3.6.1.4.1.36733.2.3.4.1  \
 --set indexed-field:userName \
 --set indexed-field:givenName \
 --set indexed-field:sn \
 --set indexed-field:mail \
 --set indexed-field:accountStatus \
 --trustAll \
 --no-prompt

${opendj_bin}/dsconfig \
  create-schema-provider \
  --hostname ${HOSTNAME} \
  --port 34444 \
  --bindDN "cn=Directory Manager" \
  --bindPassword ${PASSWD} \
  --provider-name "IDM managed/role Json Schema" \
  --type json-query-equality-matching-rule \
  --set enabled:true \
  --set case-sensitive-strings:false \
  --set ignore-white-space:true \
  --set matching-rule-name:caseIgnoreJsonQueryMatchManagedRole \
  --set matching-rule-oid:1.3.6.1.4.1.36733.2.3.4.2  \
  --set indexed-field:"condition/**" \
  --set indexed-field:"temporalConstraints/**" \
  --trustAll \
  --no-prompt


 ${opendj_bin}/dsconfig \
   create-schema-provider \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --provider-name "IDM Relationship Json Schema" \
   --type json-query-equality-matching-rule \
   --set enabled:true \
   --set case-sensitive-strings:false \
   --set ignore-white-space:true \
   --set matching-rule-name:caseIgnoreJsonQueryMatchRelationship \
   --set matching-rule-oid:1.3.6.1.4.1.36733.2.3.4.3  \
   --set indexed-field:firstResourceCollection \
   --set indexed-field:firstResourceId \
   --set indexed-field:firstPropertyName \
   --set indexed-field:secondResourceCollection \
   --set indexed-field:secondResourceId \
   --set indexed-field:secondPropertyName \
   --trustAll \
   --no-prompt

 ${opendj_bin}/dsconfig \
   create-schema-provider \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --provider-name "IDM Cluster Object Json Schema" \
   --type json-query-equality-matching-rule \
   --set enabled:true \
   --set case-sensitive-strings:false \
   --set ignore-white-space:true \
   --set matching-rule-name:caseIgnoreJsonQueryMatchClusterObject \
   --set matching-rule-oid:1.3.6.1.4.1.36733.2.3.4.4  \
   --set indexed-field:"timestamp" \
   --set indexed-field:"state" \
   --trustAll \
   --no-prompt

echo "policy configured"

echo "Copy the IDM LDIF schema to the DS schema folder"

cp ${LDIF_LOCATION}/99-openidm.ldif ${FORGEROCK_HOME}/opendj/db/schema/


echo "restart opendj"

${opendj_bin}/stop-ds --restart

echo "Add Backend indexes"


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-managed-user-json \
   --set index-type:equality \
   --trustAll \
   --no-prompt


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-managed-role-json \
   --set index-type:equality \
   --trustAll \
   --no-prompt


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-relationship-json \
   --set index-type:equality \
   --trustAll \
   --no-prompt

 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-cluster-json \
   --set index-type:equality \
   --trustAll \
   --no-prompt


  ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-json \
   --set index-type:equality \
   --trustAll \
   --no-prompt


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-link-type \
   --set index-type:equality \
   --trustAll \
   --no-prompt


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-link-firstid \
   --set index-type:equality \
   --trustAll \
   --no-prompt


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-link-secondid \
   --set index-type:equality \
   --trustAll \
   --no-prompt


 ${opendj_bin}/dsconfig \
   create-backend-index  \
   --hostname ${HOSTNAME} \
   --port 34444 \
   --bindDN "cn=Directory Manager" \
   --bindPassword ${PASSWD} \
   --backend-name userRoot \
   --index-name fr-idm-link-qualifier \
   --set index-type:equality \
   --trustAll \
   --no-prompt


echo " rebuild the indexes"

${opendj_bin}/rebuild-index \
  --hostname ${HOSTNAME} \
  --port 34444 \
  --bindDN "cn=Directory Manager" \
  --bindPassword ${PASSWD} \
  --baseDN ${BASE_DN}
  --rebuildAll \
  --start 0 \
  --trustAll


  echo "Import the populate_users.ldif"
cp ${LDIF_LOCATION}/populate_users.ldif ${FORGEROCK_HOME}/opendj/populate_users.ldif

${opendj_bin}/Import-ldif \
 --ldifFile ${USER_HOME}/opendj/populate_users.ldif \
 --backendID userRoot \
 --hostName ${HOSTNAME} \
 --port 34444 \
 --bindDN "cn=Directory Manager" \
 --bindPassword ${PASSWD} \
 --trustAll \
 --noPropertiesFile
 --no-prompt



echo
echo "changed=yes comment='opendj configured successfully.'"
exit 0
