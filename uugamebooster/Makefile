# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2021 ImmortalWrt.org
# Copyright (C) 2021 KFERMercer <KFER.Mercer@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
#
#
# to get the latest version & sha256 checksum:
# wget -O uu.tar.gz "$(curl -s -H "Accept:text/plain" "http://router.uu.163.com/api/plugin?type=openwrt-$(UU_ARCH)")" && sha256sum uu.tar.gz


include $(TOPDIR)/rules.mk

PKG_NAME:=uugamebooster
PKG_VERSION:=14.2.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(ARCH).tar.gz
PKG_SOURCE_URL:=https://uurouter.gdl.netease.com/uuplugin/openwrt-$(ARCH)/v$(PKG_VERSION)/uu.tar.gz?
ifeq ($(ARCH),aarch64)
  PKG_HASH:=45e533002ffaa79931528adcd253b35d043e5c47f4e910964e021ea2c72d5bf8
else ifeq ($(ARCH),arm)
  PKG_HASH:=0170d1e4e732e35e39c704db0fe9bb4ba01d5ccb94530ec5c2468bc6d70a4a08
else ifeq ($(ARCH),mipsel)
  PKG_HASH:=656402fddc8a51889096377a75d00e2a9a129a604578e569e1b629dac68f7247
else ifeq ($(ARCH),x86_64)
  PKG_HASH:=587b812fff79c89b57cc0aefec58dc391b285f1de1cf1d998fa00c477e5b1840
endif

PKG_LICENSE:=Proprietary

include $(INCLUDE_DIR)/package.mk

STRIP:=true

TAR_CMD=$(HOST_TAR) -C $(1)/ $(TAR_OPTIONS)

define Package/uugamebooster
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=@(aarch64||arm||mipsel||x86_64) +kmod-tun
  TITLE:=NetEase UU Game Booster
  URL:=https://uu.163.com
endef

define Package/uugamebooster/description
  NetEase's UU Game Booster Accelerates Triple-A Gameplay and Market.
endef

define Build/Compile
endef

define Package/uugamebooster/conffiles
/.uuplugin_uuid
/usr/share/uugamebooster/uu.conf
/etc/config/uugamebooster
endef

define Package/uugamebooster/install
	$(INSTALL_DIR) $(1)/usr/libexec/uugamebooster
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uuplugin $(1)/usr/libexec/uugamebooster/uugamebooster
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/xtables-nft-multi $(1)/usr/libexec/uugamebooster/xtables-nft-multi

	$(INSTALL_DIR) $(1)/usr/share/uugamebooster
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/uu.conf $(1)/usr/share/uugamebooster/uu.conf

	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/init.d
	$(INSTALL_CONF) ./files/uugamebooster.config $(1)/etc/config/uugamebooster
	$(INSTALL_BIN) ./files/uugamebooster.init $(1)/etc/init.d/uugamebooster
endef

define Package/uugamebooster/postinst
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] || exit 0

# 添加 UU 防火墙 zone
uci -q get firewall.uu_zone || {
    uci set firewall.uu_zone=zone
    uci set firewall.uu_zone.name='UU'
    uci set firewall.uu_zone.input='ACCEPT'
    uci set firewall.uu_zone.output='ACCEPT'
    uci set firewall.uu_zone.forward='ACCEPT'
    uci set firewall.uu_zone.device='tun16+'
}

# 添加 lan 到 UU 的 forwarding
uci -q get firewall.uu_forwarding || {
    uci set firewall.uu_forwarding=forwarding
    uci set firewall.uu_forwarding.src='lan'
    uci set firewall.uu_forwarding.dest='UU'
}

# 添加 UU 到 lan 的 forwarding
uci -q get firewall.uu_reverse_forwarding || {
    uci set firewall.uu_reverse_forwarding=forwarding
    uci set firewall.uu_reverse_forwarding.src='UU'
    uci set firewall.uu_reverse_forwarding.dest='lan'
}

# 应用配置
uci commit firewall
/etc/init.d/firewall reload >/dev/null 2>&1
exit 0
endef

define Package/uugamebooster/postrm
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] || exit 0

# 删除 lan -> UU 的 forwarding
uci delete firewall.uu_forwarding 2>/dev/null

# 删除 UU -> lan 的 forwarding
uci delete firewall.uu_reverse_forwarding 2>/dev/null

# 删除 uu 的 zone
uci delete firewall.uu_zone 2>/dev/null

# 应用配置
uci commit firewall
/etc/init.d/firewall reload >/dev/null 2>&1
exit 0
endef

$(eval $(call BuildPackage,uugamebooster))
