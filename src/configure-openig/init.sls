include:
  - forgerock-user
  - copy-installers



copy-ig-root-war:
  file.copy:
      - name: {{ pillar['tomcat']['catalina_base'] }}/webapps/ROOT.war
      - source: {{ pillar['forgerock']['installer-location'] }}/{{ pillar['openig']['installer'] }}
      - mode: 755
      - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
      - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
      - force : True
      - require:
        - sls: forgerock-user
        - sls: copy-installers
  service.running:
    - name: tomcat
    - enable: True
    - watch:
      - file: /etc/systemd/system/tomcat.service
