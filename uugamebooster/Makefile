# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=uugamebooster
PKG_VERSION:=9.2.10
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(ARCH).tar.gz
PKG_SOURCE_URL:=https://uu.gdl.netease.com/uuplugin/openwrt-$(ARCH)/v$(PKG_VERSION)/uu.tar.gz?
ifeq ($(ARCH),aarch64)
  PKG_HASH:=a605b412eeb7bdf198668b81c7f96308b63318320a9e7de86a242a9200bc9534
else ifeq ($(ARCH),arm)
  PKG_HASH:=0d4060f22e1dfa7d2058b2a73dd8415033c34ccd6609c20568e689650069536a
else ifeq ($(ARCH),mipsel)
  PKG_HASH:=dd88577847cbaccde8ce1a7208d00692726b54de132f58f5be4c849ba1f17421
else ifeq ($(ARCH),x86_64)
  PKG_HASH:=3505ee49865682235155f642744e8150de2c734ad5aa5b52e1cef0653a15b72a
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
endef

define Package/uugamebooster/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uuplugin $(1)/usr/bin/uugamebooster
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/xtables-nft-multi $(1)/usr/bin/xtables-nft-multi

	$(INSTALL_DIR) $(1)/usr/share/uugamebooster
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/uu.conf $(1)/usr/share/uugamebooster/uu.conf

	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/init.d
	$(INSTALL_CONF) ./files/uugamebooster.config $(1)/etc/config/uugamebooster
	$(INSTALL_BIN) ./files/uugamebooster.init $(1)/etc/init.d/uugamebooster
endef

$(eval $(call BuildPackage,uugamebooster))