################################################################################
#
# cdebootstrap
#
################################################################################

DEBOOTSTRAP_VERSION = 1.0.123
DEBOOTSTRAP_SOURCE = debootstrap_$(DEBOOTSTRAP_VERSION).tar.gz
DEBOOTSTRAP_SITE = http://http.debian.net/debian/pool/main/d/debootstrap
DEBOOTSTRAP_LICENSE = GPLv2
DEBOOTSTRAP_LICENSE_FILES = debian/copyright
DEBOOTSTRAP_INSTALL_STAGING = NO
DEBOOTSTRAP_INSTALL_TARGET = YES
DEBOOTSTRAP_AUTORECONF = YES

define DEBOOTSTRAP_BUILD_CMDS
endef

define DEBOOTSTRAP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/share/debootstrap
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/debootstrap/scripts $(@D)/scripts/*
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/debootstrap $(@D)/functions
	sed 's/@VERSION@/$(VERSION)/g' $(@D)/debootstrap > $(TARGET_DIR)/usr/bin/debootstrap
	chmod 0755 $(TARGET_DIR)/usr/bin/debootstrap
endef

$(eval $(generic-package))
