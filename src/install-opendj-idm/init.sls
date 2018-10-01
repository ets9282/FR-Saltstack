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
{% set hostname = pillar['opendj']['config']['hostname'] %}
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
    - name: {{scripts_location}}/install_opendj-ext.sh
    - source: salt://install-opendj-idm/install_opendj.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - sls: forgerock-user
      - sls: install-java
  cmd.run:
    - name: {{scripts_location}}/install_opendj-ext.sh
    - user: {{ username }}
    - group: {{ group }}
    - env:
      - JAVA_HOME: {{java_home}}
      - OPENDJ_JAVA_HOME: {{java_home}}
      - FORGEROCK_HOME: {{forgerock_home}}
      - PASSWD: {{passwd}}
      - BASE_DN: {{base_dn}}
      - HOSTNAME: {{hostname}}
    - stateful: True
    - onchanges:
      - file: run-dj-install-script


copy-ldif-files:
  file.recurse:
    - name: {{scripts_location}}/ldif-ext/
    - makeDirs: True
    - source: salt://install-opendj-idm/ldif
    - template: jinja
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - require:
      - cmd: run-dj-install-script


run-dj-configuration-script:
    file.managed:
      - name: {{scripts_location}}/configure_opendj-ext.sh
      - source: salt://install-opendj-idm/configure_opendj.sh
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
      - name: {{scripts_location}}/configure_opendj-ext.sh
      - user: {{ username }}
      - group: {{ group }}
      - env:
        - JAVA_HOME: {{java_home}}
        - OPENDJ_JAVA_HOME: {{java_home}}
        - FORGEROCK_HOME: {{forgerock_home}}
        - PASSWD: {{passwd}}
        - BASE_DN: {{base_dn}}
        - HOSTNAME: {{hostname}}
        - LDIF_LOCATION: {{scripts_location}}/ldif-ext
        - USER_HOME: {{user_home}}
      - stateful: True
      - onchanges:
        - file: run-dj-configuration-script

opendj-service-idm:
  file.managed:
    - name: /etc/systemd/system/opendj-ext.service
    - source: salt://install-opendj-idm/opendj-ext.service
    - template: jinja
    - makedirs: True
    - mode: 744
    - require:
      - cmd: run-dj-install-script
  service.enabled:
    - name: opendj-ext

add-forgerock-home-to-bash-profile:
  file.append:
    - name: {{user_home}}/.bash_profile
    - text: export FORGEROCK_HOME={{forgerock_home}}


add-opendj-to-path:
  file.append:
    - name: {{user_home}}/.bash_profile
    - text: export PATH={{ [current_path,   java_home + '/bin' + ':' + forgerock_home + '/opendj/bin']|join(':') }}
    - require:
      - cmd: run-dj-install-script
