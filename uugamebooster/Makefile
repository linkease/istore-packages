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
PKG_VERSION:=9.2.18
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(ARCH).tar.gz
PKG_SOURCE_URL:=https://uu.gdl.netease.com/uuplugin/openwrt-$(ARCH)/v$(PKG_VERSION)/uu.tar.gz?
ifeq ($(ARCH),aarch64)
  PKG_HASH:=fc35c3b52c5d896909d66ade493f9e485a8d3ca5dfd45fc4ef612ba68ab7017b
else ifeq ($(ARCH),arm)
  PKG_HASH:=2c518bf158901cea3a44e6babc71378fb3578c09130b8d1a6354d274b154a539
else ifeq ($(ARCH),mipsel)
  PKG_HASH:=19918cb21496658ebce9eceb660df8bc0959dc90c19e6f31b82a73e5fc707da9
else ifeq ($(ARCH),x86_64)
  PKG_HASH:=1fdd14b91bbf605c336ca44b04de3de44b7e5a729ee6623e6d3e4c9d8cbd6a0e
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

# 应用配置
uci commit firewall
/etc/init.d/firewall reload >/dev/null 2>&1
endef

define Package/uugamebooster/postrm
#!/bin/sh
[ -z "$${IPKG_INSTROOT}" ] || exit 0

# 删除 lan -> UU 的 forwarding
uci delete firewall.uu_forwarding 2>/dev/null

# 删除 name='UU' 的 zone
uci delete firewall.uu_zone 2>/dev/null

# 应用配置
uci commit firewall
/etc/init.d/firewall reload >/dev/null 2>&1
endef

$(eval $(call BuildPackage,uugamebooster))
