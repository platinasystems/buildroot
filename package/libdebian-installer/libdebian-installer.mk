################################################################################
#
# libdebian-installer
#
################################################################################


LIBDEBIAN_INSTALLER_VERSION = 0.104
LIBDEBIAN_INSTALLER_SOURCE = libdebian-installer_$(LIBDEBIAN_INSTALLER_VERSION).tar.xz
LIBDEBIAN_INSTALLER_SITE = http://snapshot.debian.org/archive/debian-debug/20160218T034808Z/pool/main/libd/libdebian-installer/
LIBDEBIAN_INSTALLER_LICENSE = GPLv2
LIBDEBIAN_INSTALLER_LICENSE_FILES = debian/copyright
LIBDEBIAN_INSTALLER_INSTALL_STAGING = YES
# Provided files are too old (missing reference to newly added source files)
LIBDEBIAN_INSTALLER_AUTORECONF = YES
LIBDEBIAN_INSTALLER_DEPENDENCIES = check host-pkgconf

$(eval $(autotools-package))
