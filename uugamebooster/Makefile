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
PKG_VERSION:=11.0.14
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(ARCH).tar.gz
PKG_SOURCE_URL:=https://uurouter.gdl.netease.com/uuplugin/openwrt-$(ARCH)/v$(PKG_VERSION)/uu.tar.gz?
ifeq ($(ARCH),aarch64)
  PKG_HASH:=b43907eb2dcb92d9cfa9d0ad9161bb41316ce51bda4d09606b73d87d00132282
else ifeq ($(ARCH),arm)
  PKG_HASH:=0b452f68c4de38ceb751d7505ba21df5000eedf2f4c29de8fce4bb9149391b8f
else ifeq ($(ARCH),mipsel)
  PKG_HASH:=b52ffdf1310386add2aac37e22ff400c05c5ac716f6ebfbf68178b6e37113f8c
else ifeq ($(ARCH),x86_64)
  PKG_HASH:=baa74a8ac5be31d046fec63cb050e41371c60d25665d0f5f14e0e4c42d6fafdf
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
