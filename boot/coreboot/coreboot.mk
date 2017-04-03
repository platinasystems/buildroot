################################################################################
#
# coreboot
#
################################################################################

COREBOOT_VERSION = $(call qstrip,$(BR2_TARGET_COREBOOT_VERSION))

COREBOOT_LICENSE = GPLv2+
COREBOOT_LICENSE_FILES = Licenses/gpl-2.0.txt

COREBOOT_INSTALL_IMAGES = YES

define COREBOOT_BUILD_TOOLCHAIN
	$(MAKE) -C $(@D) $(COREBOOT_MAKE_OPTS)		\
		crossgcc-i386
endef

COREBOOT_POST_CONFIGURE_HOOKS += COREBOOT_BUILD_TOOLCHAIN

ifeq ($(COREBOOT_VERSION),custom)
# Handle custom coreboot tarballs as specified by the configuration
COREBOOT_TARBALL = $(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_TARBALL_LOCATION))
COREBOOT_SITE = $(patsubst %/,%,$(dir $(COREBOOT_TARBALL)))
COREBOOT_SOURCE = $(notdir $(COREBOOT_TARBALL))
BR_NO_CHECK_HASH_FOR += $(COREBOOT_SOURCE)
else ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_GIT),y)
COREBOOT_SITE = $(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_REPO_URL))
COREBOOT_SITE_METHOD = git
COREBOOT_GIT_SUBMODULES = YES
else ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_HG),y)
COREBOOT_SITE = $(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_REPO_URL))
COREBOOT_SITE_METHOD = hg
else ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_SVN),y)
COREBOOT_SITE = $(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_REPO_URL))
COREBOOT_SITE_METHOD = svn
else
# Handle stable official coreboot versions
COREBOOT_SITE = http://www.coreboot.org/releases
COREBOOT_SOURCE = coreboot-$(COREBOOT_VERSION).tar.xz
ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_VERSION),y)
BR_NO_CHECK_HASH_FOR += $(COREBOOT_SOURCE)
endif
endif

# Analogous code exists in linux/linux.mk. Basically, the generic
# package infrastructure handles downloading and applying remote
# patches. Local patches are handled depending on whether they are
# directories or files.
COREBOOT_PATCHES = $(call qstrip,$(BR2_TARGET_COREBOOT_PATCH))
COREBOOT_PATCH = $(filter ftp://% http://% https://%,$(COREBOOT_PATCHES))

define COREBOOT_APPLY_LOCAL_PATCHES
	for p in $(filter-out ftp://% http://% https://%,$(COREBOOT_PATCHES)) ; do \
		if test -d $$p ; then \
			$(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
		else \
			$(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
		fi \
	done
endef
COREBOOT_POST_PATCH_HOOKS += COREBOOT_APPLY_LOCAL_PATCHES

ifeq ($(BR2_TARGET_COREBOOT_USE_DEFCONFIG),y)
COREBOOT_KCONFIG_DEFCONFIG = $(call qstrip,$(BR2_TARGET_COREBOOT_BOARD_DEFCONFIG))_defconfig
else ifeq ($(BR2_TARGET_COREBOOT_USE_CUSTOM_CONFIG),y)
COREBOOT_KCONFIG_FILE = $(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_CONFIG_FILE))
endif # BR2_TARGET_COREBOOT_USE_DEFCONFIG

COREBOOT_KCONFIG_EDITORS = menuconfig xconfig gconfig nconfig
COREBOOT_KCONFIG_OPTS = $(COREBOOT_MAKE_OPTS)
define COREBOOT_HELP_CMDS
	@echo '  coreboot-menuconfig       - Run coreboot menuconfig'
	@echo '  coreboot-savedefconfig    - Run coreboot savedefconfig'
	@echo '  coreboot-update-defconfig - Save the coreboot configuration to the path specified'
	@echo '                             by BR2_TARGET_COREBOOT_CUSTOM_CONFIG_FILE'
endef

define COREBOOT_BUILD_CMDS
		$(MAKE) -C $(@D) 	\
		$(COREBOOT_MAKE_TARGET)
endef

ifeq ($(BR2_TARGET_COREBOOT)$(BR_BUILDING),yy)

ifeq ($(BR2_TARGET_COREBOOT_USE_DEFCONFIG),y)
ifeq ($(call qstrip,$(BR2_TARGET_COREBOOT_BOARD_DEFCONFIG)),)
$(error No board defconfig name specified, check your BR2_TARGET_COREBOOT_DEFCONFIG setting)
endif # qstrip BR2_TARGET_COREBOOT_BOARD_DEFCONFIG
endif # BR2_TARGET_COREBOOT_USE_DEFCONFIG
ifeq ($(BR2_TARGET_COREBOOT_USE_CUSTOM_CONFIG),y)
ifeq ($(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_CONFIG_FILE)),)
$(error No board configuration file specified, check your BR2_TARGET_COREBOOT_CUSTOM_CONFIG_FILE setting)
endif # qstrip BR2_TARGET_COREBOOT_CUSTOM_CONFIG_FILE
endif # BR2_TARGET_COREBOOT_USE_CUSTOM_CONFIG

#
# Check custom version option
#
ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_VERSION),y)
ifeq ($(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_VERSION_VALUE)),)
$(error No custom coreboot version specified. Check your BR2_TARGET_COREBOOT_CUSTOM_VERSION_VALUE setting)
endif # qstrip BR2_TARGET_COREBOOT_CUSTOM_VERSION_VALUE
endif # BR2_TARGET_COREBOOT_CUSTOM_VERSION

#
# Check custom tarball option
#
ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_TARBALL),y)
ifeq ($(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_TARBALL_LOCATION)),)
$(error No custom coreboot tarball specified. Check your BR2_TARGET_COREBOOT_CUSTOM_TARBALL_LOCATION setting)
endif # qstrip BR2_TARGET_COREBOOT_CUSTOM_TARBALL_LOCATION
endif # BR2_TARGET_COREBOOT_CUSTOM_TARBALL

#
# Check Git/Mercurial repo options
#
ifeq ($(BR2_TARGET_COREBOOT_CUSTOM_GIT)$(BR2_TARGET_COREBOOT_CUSTOM_HG),y)
ifeq ($(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_REPO_URL)),)
$(error No custom coreboot repository URL specified. Check your BR2_TARGET_COREBOOT_CUSTOM_REPO_URL setting)
endif # qstrip BR2_TARGET_COREBOOT_CUSTOM_CUSTOM_REPO_URL
ifeq ($(call qstrip,$(BR2_TARGET_COREBOOT_CUSTOM_REPO_VERSION)),)
$(error No custom coreboot repository URL specified. Check your BR2_TARGET_COREBOOT_CUSTOM_REPO_VERSION setting)
endif # qstrip BR2_TARGET_COREBOOT_CUSTOM_CUSTOM_REPO_VERSION
endif # BR2_TARGET_COREBOOT_CUSTOM_GIT || BR2_TARGET_COREBOOT_CUSTOM_HG

endif # BR2_TARGET_COREBOOT && BR_BUILDING

$(eval $(kconfig-package))
