include:
  - forgerock-user
  - copy-installers
  - install-java

install-openidm:
  archive.extracted:
    - name: {{ pillar['forgerock']['forgerock-home'] }}
    - source: {{ pillar['forgerock']['installer-location'] }}/{{ pillar['openidm']['installer'] }}
    - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
    - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
    - require:
      - sls: forgerock-user
      - sls: copy-installers
      - sls: install-java

copy-init:
  file.managed:
      - name: {{ pillar['forgerock']['forgerock-home'] }}/openidm/bin/openidm
      - source: salt://install-openidm/openidm.sh
      - template: jinja
      - makedirs: True
      - mode: 744
      - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
      - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
      - require:
        - archive: install-openidm

opendj-service:
  file.managed:
    - name: /etc/systemd/system/openidm.service
    - source: salt://install-openidm/openidm.service
    - template: jinja
    - makedirs: True
    - mode: 744
    - require:
      - file: copy-init
  service.enabled:
    - name: openidm

restart-openidm:
  service.running:
      - name: openidm
      - enable: True
