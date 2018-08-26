{{ pillar['forgerock']['forgerock-user']['username'] }}:
  user.present:
    - fullname: forgerock
    - shell: /bin/bash
    - home: {{ pillar['forgerock']['forgerock-user']['home']}}

{{ pillar['forgerock']['forgerock-user']['home'] }}:
  file.directory:
    - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
    - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
    - mode: 755
    - makedirs: True


{{ pillar['forgerock']['scripts-location'] }}:
  file.directory:
    - user: {{ pillar['forgerock']['forgerock-user']['username'] }}
    - group: {{ pillar['forgerock']['forgerock-user']['group'] }}
    - mode: 755
    - makedirs: True
