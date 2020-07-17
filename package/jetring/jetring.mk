################################################################################
#
# jetring
#
################################################################################

JETRING_VERSION = 0.25
JETRING_SOURCE = jetring_$(JETRING_VERSION).tar.xz
JETRING_SITE = http://http.debian.net/debian/pool/main/j/jetring
JETRING_LICENSE = GPL-2+
JETRING_LICENSE_FILES = debian/copyright

HOST_JETRING_DEPENDENCIES = host-gnupg

define HOST_JETRING_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) build
endef

define HOST_JETRING_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) DESTDIR=$(HOST_DIR) -C $(@D) install
endef

$(eval $(host-generic-package))
