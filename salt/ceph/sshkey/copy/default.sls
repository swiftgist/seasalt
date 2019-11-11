
{% set default_key = salt['file.find']('/root/.ssh/id_*.pub') | first %}

copy ssh key:
  module.run:
    - name: file.copy
    - src: {{ salt['pillar.get']('root_ssh_key', default_key) }}
    - dst: /opt/seasalt/salt/ceph/sshkey/files/seasalt.pub

