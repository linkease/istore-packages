include $(TOPDIR)/rules.mk

PKG_NAME:=r8125
PKG_RELEASE=9.008.00

PKG_MAINTAINER:=Yibai Zhang <xm1994@gmail.com>
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/r8125
  SUBMENU:=Network Devices
  TITLE:=Driver for Realtek 8125 series devices
  DEPENDS:=@PCI_SUPPORT +kmod-mii +kmod-phy-realtek
  FILES:=\
	$(PKG_BUILD_DIR)/r8125.ko
  AUTOLOAD:=$(call AutoProbe,r8125)
  PROVIDES:=kmod-r8125
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C "$(LINUX_DIR)" \
		$(KERNEL_MAKE_FLAGS) \
		M="$(PKG_BUILD_DIR)" \
		modules
endef

$(eval $(call KernelPackage,r8125))

