base:
  'openam*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-tomcat
    - install-openam
    - configure-openam
    - config-hostnames
  'master*':
    - forgerock-user
    - install-java
    - install-tomcat
    - install-opendj
    - config-hostnames
  'openidm*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-openidm
    - config-hostnames
  'openig*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-openig
    - config-hostnames

  'opendj*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-opendj-idm
    - config-hostnames
