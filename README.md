# SeaSalt
A small collection of Salt files for provisioning a Salt cluster prior to deploying Ceph using the ssh orchestrator.  The scope of this project is intentionally limited to dependencies needed by Ceph but are outside the scope of the Ceph ssh orchestrator.

## Commands

The highest level orchestration that will execute all the Salt state files is
```
# salt-run state.orch ceph.setup
``` 

For running only a single orchestration, run any of the following:
```
# salt-run state.orch ceph.setup.apparmor
# salt-run state.orch ceph.setup.sshkey
# salt-run state.orch ceph.setup.time
# salt-run state.orch ceph.setup.tuned
```

## Caveats
Configure `/opt/seasalt/pillar/ceph/seasalt_minion.sls`.  The default Salt target relies on grains.  See [Salt modules](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.grains.html).  Otherwise, uncomment one of the other examples in the file.

Note that the default `time_server` is set to your Salt master.  Either configure chrony, ntp or set the `time_server` to a valid source by editing `/opt/seasalt/pillar/ceph/global.yml`.

Lastly, the current tuned orchestration applies the _throughput_ profile to all of the `seasalt_minions`.  Consider applying the _latency_ profile to any minions intended to host Ceph monitors.

