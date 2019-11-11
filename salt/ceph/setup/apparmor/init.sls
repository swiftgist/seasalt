
include:
  - .{{ salt['pillar.get']('setup_apparmor', 'default') }}

