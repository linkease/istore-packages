# Copyright (C) 2019 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for cpulimit
LUCI_DEPENDS:=+cpulimit-ng
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=3

define Package/$(PKG_NAME)/conffiles
/etc/config/cpulimit
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
