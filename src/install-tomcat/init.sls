include:
  - forgerock-user
  - install-java


{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}
{% set user_home = pillar['forgerock']['forgerock-user']['home'] %}
{% set username = pillar['forgerock']['forgerock-user']['username'] %}
{% set group = pillar['forgerock']['forgerock-user']['group'] %}
{% set installer_location = pillar['forgerock']['installer-location'] %}
{% set tomcat_installer = pillar['tomcat']['installer'] %}
{% set forgerock_home = pillar['forgerock']['forgerock-home'] %}


copy-tomcat-installer:
  file.managed:
    - name: {{ installer_location + '/' + tomcat_installer }}
    - source: salt://installers/{{ tomcat_installer }}
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - makedirs: True
    - require:
      - sls: forgerock-user


install-tomcat:
  archive.extracted:
    - name: {{ forgerock_home }}/tomcat
    - source: {{ installer_location + '/' + tomcat_installer }}
    - user: {{ username }}
    - group: {{ group }}
    - enforce_ownership_on: {{ forgerock_home }}/tomcat
    - require:
      - sls: forgerock-user
      - file: copy-tomcat-installer

tomcat-service:
  file.managed:
    - name: /etc/systemd/system/tomcat.service
    - source: salt://install-tomcat/tomcat.service
    - template: jinja
    - makedirs: True
    - mode: 744
    - require:
      - archive: install-tomcat
  service.running:
    - name: tomcat
    - enable: True
    - watch:
      - file: /etc/systemd/system/tomcat.service
