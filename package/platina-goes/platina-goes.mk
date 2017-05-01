###############################################################################
#
# platina-goes
#
################################################################################

PLATINA_GOES_VERSION = master
PLATINA_GOES_SITE = https://github.com/platinasystems/go
PLATINA_GOES_SITE_METHOD = git
PLATINA_GOES_GIT_SUBMODULES = YES

PLATINA_GOES_LICENSE = GPLv2+
PLATINA_GOES_LICENSE_FILES = LICENSE

PLATINA_GOES_DEPENDENCIES = host-go
ifeq ($(BR2_PACKAGE_PLATINA_FE1),y)
PLATINA_GOES_DEPENDENCIES += platina-fe1
endif

PLATINA_GOES_GOPATH = "$(@D)"
PLATINA_GOES_MAKE_ENV = $(HOST_GO_TARGET_ENV) \
	GOBIN="$(@D)/bin" \
	GOPATH="$(PLATINA_GOES_GOPATH)"

ifeq ($(BR2_STATIC_LIBS),y)
PLATINA_GOES_GLDFLAGS += -extldflags '-static'
endif

ifeq ($(BR2_arm),y)
PLATINA_GOES_GLDFLAGS += -d
endif

PLATINA_GOES_TAGS = $(subst $\",,$(BR2_PACKAGE_PLATINA_GOES_TAGS))

ifeq ($(BR2_PACKAGE_PLATINA_GOES_EXAMPLE),y)
PLATINA_GOES_TARGETS += goes-example
endif

ifeq ($(BR2_PACKAGE_PLATINA_GOES_EXAMPLE_ARM),y)
PLATINA_GOES_TARGETS += goes-example-arm
endif

ifeq ($(BR2_PACKAGE_PLATINA_GOES_MK1_BMC),y)
PLATINA_GOES_TARGETS += goes-platina-mk1-bmc
endif

ifeq ($(BR2_PACKAGE_PLATINA_GOES_MK1),y)
PLATINA_GOES_TARGETS += goes-platina-mk1
endif

ifeq ($(BR2_PACKAGE_PLATINA_FE1),y)
define PLATINA_GOES_COPY_FE1
	mkdir -p $(PLATINA_GOES_GOPATH)/vnet/devices/ethernet/switch/fe1
	cp -r $(STAGING_DIR)/usr/lib/go/src/github.com/platinasystems/fe1/* $(PLATINA_GOES_GOPATH)/vnet/devices/ethernet/switch/fe1
endef
endif

ifeq ($(BR2_INIT_PLATINA_GOES),y)

define PLATINA_GOES_INSTALL_INIT_HOOK
	ln -fs usr/bin/goes $(TARGET_DIR)/init
endef

endif

PLATINA_GOES_POST_INSTALL_TARGET_HOOKS += \
	PLATINA_GOES_INSTALL_INIT_HOOK

define PLATINA_GOES_CONFIGURE_CMDS
	mkdir -p $(PLATINA_GOES_GOPATH)/src/github.com/platinasystems/
	ln -s $(@D) $(PLATINA_GOES_GOPATH)/src/github.com/platinasystems/go
	$(PLATINA_GOES_COPY_FE1)
endef

define PLATINA_GOES_BUILD_CMDS
	$(foreach d,$(PLATINA_GOES_TARGETS),\
		cd $(@D); env $(PLATINA_GOES_MAKE_ENV) $(HOST_DIR)/usr/bin/go build \
			-v -o $(@D)/bin/goes -tags "$(PLATINA_GOES_TAGS)" -ldflags "$(PLATINA_GOES_GLDFLAGS)" ./main/$(d)$(sep))
endef

define PLATINA_GOES_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/goes $(TARGET_DIR)/usr/bin/goes
endef

$(eval $(generic-package))
