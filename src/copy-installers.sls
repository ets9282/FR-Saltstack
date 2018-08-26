include:
  - forgerock-user

{{ pillar['forgerock']['installer-location'] }}:
  file.recurse:
    - source: salt://installers
    - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
    - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
    - file_mode: 644
    - require:
      - sls: forgerock-user