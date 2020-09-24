################################################################################
#
# ubuntu-keyring
#
################################################################################

UBUNTU_KEYRING_VERSION = 2020.06.17.1
UBUNTU_KEYRING_SOURCE = ubuntu-keyring_$(UBUNTU_KEYRING_VERSION).tar.gz
UBUNTU_KEYRING_SITE = http://archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-keyring
UBUNTU_KEYRING_LICENSE = GPL
UBUNTU_KEYRING_LICENSE_FILES = debian/copyright
UBUNTU_KEYRING_DEPENDENCIES = host-jetring

define UBUNTU_KEYRING_BUILD_CMDS
endef

define UBUNTU_KEYRING_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/share/keyrings
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/keyrings $(@D)/keyrings/*
endef

$(eval $(generic-package))
