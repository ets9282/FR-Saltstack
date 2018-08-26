include:
  - forgerock-user

{% set current_path = salt['environ.get']('PATH', '/bin:/usr/bin') %}
{% set user_home = pillar['forgerock']['forgerock-user']['home'] %}
{% set username = pillar['forgerock']['forgerock-user']['username'] %}
{% set group = pillar['forgerock']['forgerock-user']['group'] %}
{% set jdk_home = pillar['jdk']['java_home'] %}
{% set installer_location = pillar['forgerock']['installer-location'] %}
{% set jdk_installer = pillar['jdk']['installer'] %}
{% set forgerock_home = pillar['forgerock']['forgerock-home'] %}
{% set jdk_version = pillar['jdk']['version'] %}

copy-jdk-installer:
  file.managed:
    - name: {{ installer_location + '/' + jdk_installer }}
    - source: salt://installers/{{ jdk_installer }}
    - user: {{ username }}
    - group: {{ group }}
    - file_mode: 644
    - makedirs: True
    - require:
      - sls: forgerock-user


install-java:
  archive.extracted:
    - name: {{ forgerock_home }}/java
    - source: {{ installer_location + '/' + jdk_installer }}
    - enforce_ownership_on: {{ forgerock_home }}/java
    - user: {{ username }}
    - group: {{ group }}
    - require:
      - file: copy-jdk-installer


add-java-home-to-bash-profile:
  file.append:
    - name: {{user_home}}/.bash_profile
    - text: export JAVA_HOME={{jdk_home}}
    - require:
      - file: copy-jdk-installer

add-java-to-path:
  file.append:
    - name: {{user_home}}/.bash_profile
    - text: export PATH={{ [current_path, jdk_home + '/bin']|join(':') }}
    - require:
      - file: copy-jdk-installer





