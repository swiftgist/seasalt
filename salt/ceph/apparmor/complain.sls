
include:
  - .install
  - .profiles

aa-complain /etc/apparmor.d/ceph.d/common:
  cmd.run
