include:
  - forgerock-user
  - copy-installers
  - install-tomcat



{{ pillar['forgerock']['forgerock-user']['home']}}/.openig/config:
  file.recurse:
      - source: salt://install-openig/config
      - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
      - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
      - file_mode: 755
      - template: jinja
      - require:
        - sls: forgerock-user
        - sls: copy-installers
        - sls: install-tomcat

        
delete-ROOT-folder:
  file.absent:
    - name: {{ pillar['tomcat']['catalina_base'] }}/webapps/ROOT


copy-ig-war:
  file.copy:
      - name: {{ pillar['tomcat']['catalina_base'] }}/webapps/ROOT.war
      - source: {{ pillar['forgerock']['installer-location'] }}/{{ pillar['openig']['installer'] }}
      - mode: 755
      - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
      - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
      - makedirs: True
      - force : True
      - require:
        - sls: forgerock-user
        - sls: copy-installers


restart-tomcat:
  service.running:
    - name: tomcat
    - enable: True
    - watch:
      - file: /etc/systemd/system/tomcat.service
