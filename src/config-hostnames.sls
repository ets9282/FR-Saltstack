openam:
  host.present:
    - ip: {{ pillar['hostnames']['openam']['ip'] }}
    - names:
      - {{ pillar['hostnames']['openam']['name'] }}

openidm:
  host.present:
    - ip: {{ pillar['hostnames']['openidm']['ip'] }}
    - names:
      - {{ pillar['hostnames']['openidm']['name'] }}

openig:
  host.present:
    - ip: {{ pillar['hostnames']['openig']['ip'] }}
    - names:
      - {{ pillar['hostnames']['openig']['name'] }}

opendj:
  host.present:
    - ip: {{ pillar['hostnames']['opendj']['ip'] }}
    - names:
      - {{ pillar['hostnames']['opendj']['name'] }}
