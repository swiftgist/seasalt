
include:
  - .install
  - .profiles

"aa-disable /etc/apparmor.d/ceph.d/common || true":
  cmd.run
