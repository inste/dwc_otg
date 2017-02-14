include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=dwc_otg_272
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  SUBMENU:=USB Support
  DEPENDS:=@TARGET_rt305x_kn_ra||@TARGET_rt305x_kng_ra||@TARGET_rt305x_kg_ra @!PACKAGE_kmod-ralink_dwc_otg
  TITLE:=Synopsys DWC OTG USB driver v.2.72 for Ralink RT305x
  KCONFIG:= \
	CONFIG_DWC_OTG \
	CONFIG_DWC_OTG_HOST_ONLY=y
  FILES:=$(PKG_BUILD_DIR)/src/dwc_otg/dwc_otg.ko \
	$(PKG_BUILD_DIR)/src/lm_interface/lm.ko
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/src
	$(CP) ./src/* $(PKG_BUILD_DIR)/src
endef


define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
	        ARCH="$(LINUX_KARCH)" \
	        SUBDIRS="$(PKG_BUILD_DIR)/src" \
	        modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
