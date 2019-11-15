# Override this to install docs somewhere else
DOCDIR = /usr/share/doc/packages
VERSION ?= $(shell (git describe --tags --long --match 'v*' 2>/dev/null || echo '0.0.0') | sed -e 's/^v//' -e 's/-/+/' -e 's/-/./')

usage:
	@echo "Usage:"
	@echo -e "\tmake rpm\tBuild an RPM for installation elsewhere"
	@echo -e "\tmake test\tRun unittests"

version:
	@echo "version: "$(VERSION)

copy-files:
	# salt-master config files
	install -d m 755 $(DESTDIR)/opt/seasalt
	install -D -m 644 etc/salt/master.d/*.conf -t $(DESTDIR)/etc/salt/master.d/
	install -D -m 644 modules/modules/*.py -t $(DESTDIR)/opt/seasalt/modules/modules/
	# docs
	install -D -m 644 README.md -t $(DESTDIR)$(DOCDIR)/seasalt
	# pillar
	install -D -m 644 pillar/*.sls -t $(DESTDIR)/opt/seasalt/pillar/
	install -D -m 644 pillar/ceph/*.sls -t $(DESTDIR)/opt/seasalt/pillar/ceph
	install -D -m 644 pillar/ceph/*.yml -t $(DESTDIR)/opt/seasalt/pillar/ceph
	# states
	install -D -m 644 salt/_states/*.py -t $(DESTDIR)/opt/seasalt/salt/_states
	# modules
	install -D -m 644 salt/_modules/*.py -t $(DESTDIR)/opt/seasalt/salt/_modules
	# apparmor
	install -D -m 644 salt/ceph/apparmor/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/apparmor
	install -D -m 644 salt/ceph/apparmor/files/ceph.d/common -t $(DESTDIR)/opt/seasalt/salt/ceph/apparmor/files/ceph.d/
	install -D -m 644 salt/ceph/apparmor/install/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/apparmor/install/
	# check
	install -D -m 644 salt/ceph/check/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/check
	# macros
	install -D -m 644 salt/ceph/macros/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/macros
	install -D -m 644 salt/ceph/macros/README.md -t $(DESTDIR)/opt/seasalt/salt/ceph/macros
	# minion
	install -D -m 644 salt/ceph/minion/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/minion
	# sshkey
	install -d m 755 $(DESTDIR)/opt/seasalt/salt/ceph/sshkey/files
	install -D -m 644 salt/ceph/sshkey/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/sshkey
	install -D -m 644 salt/ceph/sshkey/copy/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/sshkey/copy
	# setup
	install -D -m 644 salt/ceph/setup/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup
	install -D -m 644 salt/ceph/setup/apparmor/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup/apparmor
	install -D -m 644 salt/ceph/setup/check/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup/check
	install -D -m 644 salt/ceph/setup/minion/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup/minion
	install -D -m 644 salt/ceph/setup/sshkey/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup/sshkey
	install -D -m 644 salt/ceph/setup/time/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup/time
	install -D -m 644 salt/ceph/setup/tuned/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/setup/tuned
	# time
	install -D -m 644 salt/ceph/time/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/time
	install -D -m 644 salt/ceph/time/README -t $(DESTDIR)/opt/seasalt/salt/ceph/time
	install -D -m 644 salt/ceph/time/chrony/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/time/chrony
	install -D -m 644 salt/ceph/time/chrony/files/*.j2 -t $(DESTDIR)/opt/seasalt/salt/ceph/time/chrony/files
	install -D -m 644 salt/ceph/time/ntp/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/time/ntp
	install -D -m 644 salt/ceph/time/ntp/files/*.j2 -t $(DESTDIR)/opt/seasalt/salt/ceph/time/ntp/files
	install -D -m 644 salt/ceph/rescind/time/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/rescind/time
	install -D -m 644 salt/ceph/rescind/time/chrony/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/rescind/time/chrony
	install -D -m 644 salt/ceph/rescind/time/ntp/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/rescind/time/ntp
	# tuned
	install -D -m 644 salt/ceph/tuned/files/*.conf -t $(DESTDIR)/opt/seasalt/salt/ceph/tuned/files
	install -D -m 644 salt/ceph/tuned/latency/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/tuned/latency
	install -D -m 644 salt/ceph/tuned/off/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/tuned/off
	install -D -m 644 salt/ceph/tuned/throughput/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/tuned/throughput
	# tests
	install -D -m 644 salt/ceph/tests/os_switch/*.sls -t $(DESTDIR)/opt/seasalt/salt/ceph/tests/os_switch

rpm: tarball
	$(eval SPECDIR := $(shell rpm -E "%{_specdir}"))
	mkdir -p $(SPECDIR)
	sed "s/VERSION$$/"$(VERSION)"/" seasalt.spec.in > $(SPECDIR)/seasalt.spec
	rpmbuild -bb $(SPECDIR)/seasalt.spec

tarball:
	$(eval TEMPDIR := $(shell mktemp -d))
	$(eval SOURCEDIR := $(shell rpm -E "%{_sourcedir}"))
	mkdir -p $(TEMPDIR)/seasalt-$(VERSION) $(SOURCEDIR)
	git archive HEAD | tar -x -C $(TEMPDIR)/seasalt-$(VERSION)
	tar -cjf $(SOURCEDIR)/seasalt-$(VERSION).tar.bz2 -C $(TEMPDIR) .
	rm -r $(TEMPDIR)

test: setup.py
	tox -e py3

lint: setup.py
	tox -e lint
