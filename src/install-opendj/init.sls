include:
  - forgerock-user
  - install-java



{% set user_home = pillar['forgerock']['forgerock-user']['home'] %}
{% set username = pillar['forgerock']['forgerock-user']['username'] %}
{% set group = pillar['forgerock']['forgerock-user']['group'] %}
{% set installer_location = pillar['forgerock']['installer-location'] %}
{% set scripts_location = pillar['forgerock']['scripts-location'] %}
{% set opendj_installer = pillar['opendj']['installer'] %}
{% set forgerock_home = pillar['forgerock']['forgerock-home'] %}
{% set java_home = pillar['jdk']['java_home'] %}
{% set passwd = pillar['opendj']['config']['password'] %}
{% set base_dn = pillar['opendj']['config']['base_dn']%}
{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}

copy-opendj-installer:
  file.managed:
    - name: {{ installer_location + '/' + opendj_installer }}
    - source: salt://installers/{{ opendj_installer }}
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - makedirs: True
    - require:
      - sls: forgerock-user

extract-opendj:
  archive.extracted:
    - name: {{ forgerock_home }}
    - source: {{ installer_location + '/' + opendj_installer }}
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - sls: forgerock-user
      - file: copy-opendj-installer


run-dj-install-script:
  file.managed:
    - name: {{scripts_location}}/install_opendj.sh
    - source: salt://install-opendj/install_opendj.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - sls: forgerock-user
      - sls: install-java
  cmd.run:
    - name: {{scripts_location}}/install_opendj.sh
    - user: {{ username }}
    - group: {{ group }}
    - env:
      - JAVA_HOME: {{java_home}}
      - OPENDJ_JAVA_HOME: {{java_home}}
      - FORGEROCK_HOME: {{forgerock_home}}
      - PASSWD: {{passwd}}
      - BASE_DN: {{base_dn}}
    - stateful: True
    - onchanges:
      - file: run-dj-install-script


copy-ldif-files:
  file.recurse:
    - name: {{scripts_location}}/ldif/
    - makeDirs: True
    - source: salt://install-opendj/ldif
    - template: jinja
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - require:
      - cmd: run-dj-install-script


run-dj-configuration-script:
    file.managed:
      - name: {{scripts_location}}/configure_opendj.sh
      - source: salt://install-opendj/configure_opendj.sh
      - template: jinja
      - makedirs: True
      - mode: 744
      - user: {{ username }}
      - group: {{ group }}
      - require:
        - sls: forgerock-user
        - sls: install-java
        - file: copy-ldif-files
    cmd.run:
      - name: {{scripts_location}}/configure_opendj.sh
      - user: {{ username }}
      - group: {{ group }}
      - env:
        - JAVA_HOME: {{java_home}}
        - OPENDJ_JAVA_HOME: {{java_home}}
        - FORGEROCK_HOME: {{forgerock_home}}
        - PASSWD: {{passwd}}
        - BASE_DN: {{base_dn}}
        - LDIF_LOCATION: {{scripts_location}}/ldif
      - stateful: True
      - onchanges:
        - file: run-dj-configuration-script

opendj-service:
  file.managed:
    - name: /etc/systemd/system/opendj.service
    - source: salt://install-opendj/opendj.service
    - template: jinja
    - makedirs: True
    - mode: 744
    - require:
      - cmd: run-dj-install-script
  service.enabled:
    - name: opendj

add-opendj-to-path:
  file.append:
    - name: {{user_home}}/.bash_profile
    - text: export PATH={{ [current_path,   java_home + '/bin' + ':' + forgerock_home + '/opendj/bin']|join(':') }}
    - require:
      - cmd: run-dj-install-script