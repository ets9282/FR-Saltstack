forgerock:
  forgerock-user:
    username: forgerock
    group: forgerock
    home: /home/forgerock
  forgerock-home: /opt/forgerock
  installer-location: /opt/forgerock/installers
  scripts-location: /opt/forgerock/scripts

hostnames:
  openam:
    ip: 192.168.50.5
    name: openam1.local
  openidm:
    ip: 192.168.50.6
    name: openidm1.local
  openig:
    ip: 192.168.50.8
    name: openig1.local
  opendj:
    ip: 192.168.50.7
    name: opendj1.local

jdk:
  version: jdk1.8.0_161
  installer: jdk-8u161-linux-x64.tar.gz
  target: /opt/forgerock/java/jdk1.8.0_161
  java_home: /opt/forgerock/java/jdk1.8.0_161

tomcat:
  version: apache-tomcat-8.5.27
  installer: apache-tomcat-8.5.27.tar.gz
  catalina_home: /opt/forgerock/tomcat/apache-tomcat-8.5.27
  catalina_base: /opt/forgerock/tomcat/apache-tomcat-8.5.27
  xms: 1024M
  xmx: 2048M

openam:
  version: AM-6.0.0
  war: openam.war
  configTool: SSOConfiguratorTools-5.1.1.3.zip
  configToolVersion: SSOConfiguratorTools-5.1.1.3
  configToolJar: openam-configurator-tool-14.1.1.3.jar
  ssoAdm: SSOAdminTools-5.1.1.3.zip
  ssoAdmVersion: SSOAdminTools-5.1.1.3
  config:
    deployment_uri: /openam
    base_dir: /opt/forgerock/openam
    locale: en_US
    platform_locale: en_US
    am_enc_key: bxloSmKOHymzVk6LTWJpkgiolbzeAeDw
    admin_pw: Welcome123
    agent_pw: Welcome1234
    accept_licenses: true
    config_data_store: embedded
    config_directory_ssl: SIMPLE
    config_directory_server: localhost
    config_directory_port: 50389
    config_directory_admin_port: 4444
    config_directory_jmx_port: 1689
    config_root_suffix: dc=openam1,dc=local
    config_ds_dirmgrdn: cn=Directory Manager
    config_ds_dirmgrpasswd: 95qy5PnOFwK0CuvS

opendj:
  version: DJ-6.0.0
  installer: opendj.zip
  config:
    base_dn: dc=local
    password: 95qy5PnOFwK0CuvS
    priv_user_dn: uid=openam,ou=admins,dc=local
    priv_user_pw: 95qy5PnOFwK0CuvS
    hostname: opendj1.local

openidm:
  version: IDM-6.0.0.2
  installer: openidm.zip


openig:
  version: IG-6.1.0
  installer: openig.war
