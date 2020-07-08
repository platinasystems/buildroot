################################################################################
#
# cdebootstrap
#
################################################################################

CDEBOOTSTRAP_VERSION = 0.7.7
CDEBOOTSTRAP_SOURCE = cdebootstrap_$(CDEBOOTSTRAP_VERSION).tar.xz
CDEBOOTSTRAP_SITE = http://http.debian.net/debian/pool/main/c/cdebootstrap
CDEBOOTSTRAP_LICENSE = GPLv2
CDEBOOTSTRAP_LICENSE_FILES = debian/copyright
CDEBOOTSTRAP_INSTALL_STAGING = NO
CDEBOOTSTRAP_INSTALL_TARGET = YES
CDEBOOTSTRAP_CONF_OPTS =
CDEBOOTSTRAP_DEPENDENCIES = libcurl libdebian-installer zlib bzip2 host-pkgconf xz

$(eval $(autotools-package))
