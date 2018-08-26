include:
  - forgerock-user
  - install-tomcat

{% set user_home = pillar['forgerock']['forgerock-user']['home'] %}
{% set username = pillar['forgerock']['forgerock-user']['username'] %}
{% set group = pillar['forgerock']['forgerock-user']['group'] %}
{% set installer_location = pillar['forgerock']['installer-location'] %}
{% set openam_installer = pillar['openam']['war'] %}
{% set openam_sso_adm = pillar['openam']['ssoAdm'] %}
{% set openam_configurator = pillar['openam']['configTool'] %}
{% set catalina_base = pillar['tomcat']['catalina_base'] %}
{% set forgerock_home = pillar['forgerock']['forgerock-home'] %}

copy-openam-installer:
  file.managed:
    - name: {{ catalina_base }}/webapps/openam.war
    - source: salt://installers/{{ openam_installer }}
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - makedirs: True
    - require:
      - sls: forgerock-user
      - sls: install-tomcat

copy-openam-configurator:
  file.managed:
    - name: {{ installer_location }}/{{openam_configurator}}
    - source: salt://installers/{{ openam_configurator }}
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - makedirs: True
    - require:
      - sls: forgerock-user
      - sls: install-tomcat
  archive.extracted:
    - name: {{ forgerock_home }}/openam_tools/configurator
    - source: {{ installer_location + '/' + openam_configurator }}
    - user: {{ username }}
    - group: {{ group }}
    - enforce_toplevel: False
    - require:
      - file: copy-openam-configurator

copy-openam-ssoadm:
  file.managed:
    - name: {{ installer_location }}/{{openam_sso_adm}}
    - source: salt://installers/{{ openam_sso_adm }}
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - makedirs: True
    - require:
      - sls: forgerock-user
      - sls: install-tomcat
  archive.extracted:
    - name: {{ forgerock_home }}/openam_tools/ssoadm
    - source: {{ installer_location + '/' + openam_sso_adm }}
    - user: {{ username }}
    - enforce_toplevel: False
    - group: {{ group }}
    - require:
      - file: copy-openam-ssoadm


restart-tomcat:
  service.running:
      - name: tomcat
      - enable: True
      - watch:
        -  file: copy-openam-installer
