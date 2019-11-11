
include:
  - .install
  - .profiles

aa-enforce /etc/apparmor.d/ceph.d/common:
  cmd.run

