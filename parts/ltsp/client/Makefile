prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
libdir = $(prefix)/lib
sbindir = $(exec_prefix)/sbin
datarootdir = $(prefix)/share
sysconfdir = $(prefix)/etc

INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

.PHONY : all
all : po/fi/puavo-remote-assistance-applet.mo

puavo-remote-assistance-applet.pot: puavo-remote-assistance-applet
	xgettext --omit-header --language Python --keyword=_tr -o $@ $^

%.po : po/puavo-client-updater-applet.pot
	msgmerge --update --no-fuzzy-matching --backup=off $@ $<
	touch $@

%.mo : %.po
	msgfmt $< --output-file $@

.PHONY : installdirs
installdirs :
	mkdir -p $(DESTDIR)/sbin
	mkdir -p $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(libdir)
	mkdir -p $(DESTDIR)$(libdir)/puavo-ltsp-client
	mkdir -p $(DESTDIR)$(libdir)/puavo-ltsp-client/pam
	mkdir -p $(DESTDIR)$(sbindir)
	mkdir -p $(DESTDIR)$(sysconfdir)/default
	mkdir -p $(DESTDIR)$(sysconfdir)/puavo-external-files-actions.d
	mkdir -p $(DESTDIR)$(sysconfdir)/puavo-vpn-client/scripts/route-up
	mkdir -p $(DESTDIR)$(sysconfdir)/init
	mkdir -p $(DESTDIR)$(sysconfdir)/init.d
	mkdir -p $(DESTDIR)$(sysconfdir)/network/if-up.d
	mkdir -p $(DESTDIR)$(sysconfdir)/NetworkManager/dispatcher.d
	mkdir -p $(DESTDIR)$(sysconfdir)/ssh
	mkdir -p $(DESTDIR)$(sysconfdir)/systemd/system/systemd-udevd.service.d
	mkdir -p $(DESTDIR)$(sysconfdir)/xdg/autostart
	mkdir -p $(DESTDIR)/lib/udev/rules.d
	mkdir -p $(DESTDIR)$(sysconfdir)/X11/Xsession.d
	mkdir -p $(DESTDIR)$(datarootdir)/applications
	mkdir -p $(DESTDIR)$(datarootdir)/gdm/greeter/autostart
	mkdir -p $(DESTDIR)$(datarootdir)/icons/hicolor/scalable/status
	mkdir -p $(DESTDIR)$(datarootdir)/locale/fi/LC_MESSAGES
	mkdir -p $(DESTDIR)$(datarootdir)/pam-configs
	mkdir -p $(DESTDIR)$(datarootdir)/puavo-conf/definitions
	mkdir -p $(DESTDIR)$(datarootdir)/puavo-conf/profile-overwrites
	mkdir -p $(DESTDIR)$(datarootdir)/puavo-ltsp-client/xsessions
	mkdir -p $(DESTDIR)$(datarootdir)/xsessions
	mkdir -p $(DESTDIR)/var/lib/puavo-desktop/shared
	mkdir -p $(DESTDIR)/var/lib/puavo-desktop/users
	mkdir -p $(DESTDIR)/lib/systemd/system
	mkdir -p $(DESTDIR)/lib/systemd/system/multi-user.target.wants

.PHONY : install
install : installdirs
	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/pam-configs \
		pam/configs/puavo-local-access

	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/puavo-conf/definitions \
		puavo-conf-parameters.json

	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/puavo-conf/profile-overwrites \
		profile-overwrites/*.json

	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/gdm/greeter/autostart \
		gdm/greeter/autostart/puavo-run-xrandr.desktop

	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/icons/hicolor/scalable/status \
		icons/puavoremoteaccess-cyan.svg \
		icons/puavoremoteaccess-green.svg \
		icons/puavoremoteaccess-grey.svg \
		icons/puavoremoteaccess-original.svg \
		icons/puavoremoteaccess-yellow.svg

	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/puavo-ltsp-client/xsessions \
		xsessions/*

	$(INSTALL_DATA) -t $(DESTDIR)$(datarootdir)/xsessions \
		xsessions/*

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(bindir) \
		puavo-pulseaudio-get-puavoconf \
		puavo-pulseaudio-list \
		puavo-pulseaudio-setup \
		puavo-remote-assistance-applet \
		puavo-rest-request

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(sbindir) \
		puavo-dnssd-printer-client \
		puavo-handle-external-files-actions \
		puavo-netboot-init-nfs \
		puavo-report-system-version

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(datarootdir)/locale/fi/LC_MESSAGES \
		po/fi/puavo-remote-assistance-applet.mo

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(sysconfdir)/puavo-vpn-client/scripts/route-up \
		etc/puavo-vpn-client/scripts/route-up/10-dnsmasq \
		etc/puavo-vpn-client/scripts/route-up/30-ntpdate

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(sysconfdir)/NetworkManager/dispatcher.d \
		etc/NetworkManager/dispatcher.d/dnssd-printers

	$(INSTALL_DATA) -t $(DESTDIR)$(sysconfdir)/systemd/system/systemd-udevd.service.d \
		etc/systemd/system/systemd-udevd.service.d/puavo-ltsp-client.conf

	$(INSTALL_DATA) -t $(DESTDIR)$(sysconfdir)/xdg/autostart \
		etc/xdg/autostart/*

	$(INSTALL_DATA) -t $(DESTDIR)/lib/udev/rules.d \
		udev/rules.d/80-puavo-printers.rules \
		udev/rules.d/95-monitor-hotplug.rules

	$(INSTALL_DATA) -t $(DESTDIR)$(sysconfdir)/X11/Xsession.d \
		etc/X11/Xsession.d/*

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(libdir)/puavo-ltsp-client \
		lib/*

	$(INSTALL_PROGRAM) -t $(DESTDIR)$(libdir)/puavo-ltsp-client/pam \
		pam/check-if-account-is-locked \
		pam/puavo-login \
		pam/puavo-manage-homedir \
		pam/puavo-nodm-pam-setup \
		pam/puavo-setup-primary-user \
		pam/restrict-logins-if-personally-administered

	$(INSTALL_DATA) -t $(DESTDIR)/lib/systemd/system \
		systemd/*

	ln -fs -t $(DESTDIR)/lib/systemd/system/multi-user.target.wants \
		../puavo-darkdm.service

	ln -fs -t $(DESTDIR)/lib/systemd/system/multi-user.target.wants \
		../puavo-report-system-version.service

.PHONY : clean
clean :
	rm -rf po/fi/*.mo
	rm -rf po/*.pot
