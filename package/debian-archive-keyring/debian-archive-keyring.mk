################################################################################
#
# debian-archive-keyring
#
################################################################################

DEBIAN_ARCHIVE_KEYRING_VERSION = 2017.5
DEBIAN_ARCHIVE_KEYRING_SOURCE = debian-archive-keyring_$(DEBIAN_ARCHIVE_KEYRING_VERSION).tar.xz
DEBIAN_ARCHIVE_KEYRING_SITE = http://http.debian.net/debian/pool/main/d/debian-archive-keyring
DEBIAN_ARCHIVE_KEYRING_LICENSE = GPL
DEBIAN_ARCHIVE_KEYRING_LICENSE_FILES = debian/copyright
DEBIAN_ARCHIVE_KEYRING_DEPENDENCIES = host-jetring

define DEBIAN_ARCHIVE_KEYRING_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) -j 1 build
endef

define DEBIAN_ARCHIVE_KEYRING_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
