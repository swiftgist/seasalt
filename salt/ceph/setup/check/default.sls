
check addresses:
  salt.state:
    - tgt: '{{ salt['master.minion']() }}'
    - tgt_type: compound
    - sls: ceph.check.addresses
