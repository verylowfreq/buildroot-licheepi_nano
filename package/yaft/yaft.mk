YAFT_VERSION = 59ef091187736200e07ee1d67d6249ad4c691542
YAFT_SITE = https://github.com/uobikiemukot/yaft
YAFT_SITE_METHOD = git
YAFT_LICENSE = MIT License
YAFT_LICENSE_FILES = LICENSE

define YAFT_BUILD_CMDS
	LANG=ja_JP.UTF-8 $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef


define YAFT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/yaft $(TARGET_DIR)/usr/bin/yaft
	$(INSTALL) -D -m 0755 $(@D)/yaft_wall $(TARGET_DIR)/usr/bin/yaft_wall
	tic -o $(TARGET_DIR)/usr/share/terminfo $(@D)/info/yaft.src
endef

$(eval $(generic-package))

