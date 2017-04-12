###############################################################################
#
# platina-fe1
#
################################################################################

PLATINA_FE1_VERSION = master
PLATINA_FE1_SITE = https://github.com/platinasystems/fe1
PLATINA_FE1_SITE_METHOD = git
PLATINA_FE1_INSTALL_STAGING = YES

PLATINA_FE1_LICENSE = BCM TITLE
PLATINA_FE1_LICENSE_FILES = LICENSE

PLATINA_FE1_DEPENDENCIES = host-go

PLATINA_FE1_GOPATH = "$(@D)"

define PLATINA_FE1_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/go/src/github.com/platinasystems/fe1
	cp -r $(@D)/* $(STAGING_DIR)/usr/lib/go/src/github.com/platinasystems/fe1
endef

$(eval $(generic-package))
