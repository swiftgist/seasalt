
/etc/apparmor.d/ceph.d/common:
  file.managed:
    - source: salt://ceph/apparmor/files/ceph.d/common
    - makedirs: True
    - perms: 600
    - user: root
    - group: root
