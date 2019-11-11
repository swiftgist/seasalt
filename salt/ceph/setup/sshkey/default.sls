
{% set master = salt['master.minion']() %}

copy sshkey:
  salt.state:
    - tgt: {{ master }}
    - tgt_type: compound
    - sls: ceph.sshkey.copy
    - failhard: True

distribute sshkey:
  salt.state:
    - tgt: '{{ salt['pillar.get']('seasalt_minions') }}'
    - tgt_type: compound
    - sls: ceph.sshkey
    - failhard: True

