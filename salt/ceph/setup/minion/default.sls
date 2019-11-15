
minion:
  salt.state:
    - tgt: '{{ salt['pillar.get']('seasalt_minions') }}'
    - tgt_type: compound
    - sls: ceph.minion
    - failhard: True

