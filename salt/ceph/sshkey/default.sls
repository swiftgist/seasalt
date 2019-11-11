
install ssh keys:
  ssh_auth.present:
    - user: root
    - source: salt://ceph/sshkey/files/seasalt.pub
    - config: /%h/.ssh/authorized_keys
