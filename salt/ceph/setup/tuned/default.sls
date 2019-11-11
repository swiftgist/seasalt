
tuned throughput:
  salt.state:
    - tgt: '{{ salt['pillar.get']('seasalt_minions') }}'
    - tgt_type: compound
    - sls: ceph.tuned.throughput
    - failhard: True

