#
# Copyright (C) 2008-2014 The LuCI Team <luci@lists.subsignal.org>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI for Zerotier
LUCI_DEPENDS:=+zerotier
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=20

define Package/luci-app-zerotier/preinst
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/init.d/zerotier ] && mv /etc/init.d/zerotier /etc/etc_initd_zerotier_backup
fi
endef

define Package/luci-app-zerotier/postrm
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/etc_initd_zerotier_backup ] && mv /etc/etc_initd_zerotier_backup /etc/init.d/zerotier
fi
endef

include $(TOPDIR)/feeds/luci/luci.mk
# call BuildPackage - OpenWrt buildroot signature
