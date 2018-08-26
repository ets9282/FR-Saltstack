include:
  - forgerock-user
  - copy-installers
  - install-tomcat


copy-ig-war:
  file.managed:
      - name: {{ pillar['tomcat']['catalina_base'] }}/webapps/ROOT.war
      - source: {{ pillar['forgerock']['installer-location'] }}/{{ pillar['openig']['installer'] }}
      - mode: 744
      - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
      - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
      - require:
        - sls: forgerock-user
        - sls: copy-installers
        - sls: install-tomcat