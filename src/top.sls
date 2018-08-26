base:
  'openam*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-tomcat
    - install-openam
    - configure-openam
  'master*':
    - forgerock-user
    - install-java
    - install-tomcat
    - install-opendj
  'openidm*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-openidm
  'openig*':
    - forgerock-user
    - copy-installers
    - install-java
    - install-tomcat
    - install-openig
