
include:
  - .{{ salt['pillar.get']('sshkey_copy', 'default') }}

