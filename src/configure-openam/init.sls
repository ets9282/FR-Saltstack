include:
  - install-openam

{% set user_home = pillar['forgerock']['forgerock-user']['home'] %}
{% set username = pillar['forgerock']['forgerock-user']['username'] %}
{% set group = pillar['forgerock']['forgerock-user']['group'] %}
{% set installer_location = pillar['forgerock']['installer-location'] %}
{% set scripts_location = pillar['forgerock']['scripts-location'] %}
{% set openam_installer = pillar['openam']['war'] %}
{% set openam_sso_adm = pillar['openam']['ssoAdm'] %}
{% set openam_configurator = pillar['openam']['configTool'] %}

{% set config_tool_jar = pillar['openam']['configToolJar'] %}

{% set catalina_base = pillar['tomcat']['catalina_base'] %}
{% set forgerock_home = pillar['forgerock']['forgerock-home'] %}

{% set am_admin_pw = pillar['openam']['config']['admin_pw'] %}
{% set java_home = pillar['jdk']['java_home']%}


copy-config-file:
  file.managed:
    - name: {{scripts_location}}/openam-config.properties
    - source: salt://configure-openam/openam-config.properties
    - template: jinja
    - makedirs: True
    - mode: 400
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - sls: install-openam

run-am-config-script:
  file.managed:
    - name: {{scripts_location}}/configure_openam.sh
    - source: salt://configure-openam/configure_openam.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - file: copy-config-file
  cmd.run:
    - name: {{ scripts_location }}/configure_openam.sh
    - user: {{ username }}
    - group: {{ group }}
    - env:
      - JAVA_HOME: {{java_home}}
      - CONFIG_TOOL_JAR: {{config_tool_jar}}
      - SCRIPTS_LOCATION: {{scripts_location}}
      - FORGEROCK_HOME: {{forgerock_home}}
    - stateful: True
    - onchanges:
      - file: run-am-config-script


run-ssoadm-config-script:
  file.managed:
    - name: {{scripts_location}}/configure_ssoadm.sh
    - source: salt://configure-openam/configure_ssoadm.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - sls: install-openam
      - cmd: run-am-config-script
  cmd.run:
    - name: {{ scripts_location }}/configure_ssoadm.sh
    - user: {{ username }}
    - group: {{ group }}
    - stateful: True
    - env:
      - JAVA_HOME: {{java_home}}
      - SCRIPTS_LOCATION: {{scripts_location}}
      - FORGEROCK_HOME: {{forgerock_home}}
      - AM_ADMIN_PW: {{am_admin_pw}}
    - onchanges:
      - file: run-ssoadm-config-script


restart-tomcat-after-config:
  service.running:
      - name: tomcat
      - enable: True
      - watch:
        -  cmd: run-am-config-script
