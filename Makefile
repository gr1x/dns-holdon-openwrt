
include $(TOPDIR)/rules.mk

PKG_NAME:=dns-holdon
PKG_RELEASE:=1
PKG_VERSION:=1


PKG_SOURCE_URL:=https://github.com/gr1x/dns-holdon/archive/master
PKG_SOURCE:=dns-holdon-master.zip
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)


include $(INCLUDE_DIR)/package.mk


define Package/dns-holdon
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libpthread
	TITLE:=DNS-Holdon -- A stub resolver/forwarder that validates DNS replies using Holdon.
endef

define Package/dns-holdon/description
	DNS-Holdon operates as a stub resolver to a known-uncensored remote recursive resolver. As several attacks on DNS inject forged DNS replies without suppressing the legitimate replies. Current implementations of DNS resolvers are vulnerable to accepting the injected replies if the attacker’s reply arrives before the legitimate one. In the case of regular DNS, this behavior allows an attacker to corrupt a victim’s interpretation of a name. \\\
	The DNS-Holdon will wait after receiving an initial reply for a “Hold-On” period to allow a subsequent legitimate reply to also arrive, and validates DNS replies with the IP TTL and the timing of the replies. As a prototype, it functions without perceptible performance decrease for undisrupted lookups.
endef

define Build/Prepare
	@echo ">>>>> Change SRC directory"
	$(Build/Prepare/Default)
	$(CP) $(BUILD_DIR)/dns-holdon-master/* $(PKG_BUILD_DIR)
endef

# The $(1) variable represents the root directory on the router running 
# OpenWrt. The $(INSTALL_DIR) variable contains a command to prepare the install 
# directory if it does not already exist.  Likewise $(INSTALL_BIN) contains the 
# command to copy the binary file from its current location (in our case the build
# directory) to the install directory.
define Package/dns-holdon/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dadder $(1)/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./conf/dadder.init $(1)/etc/init.d/dadder
	$(INSTALL_DATA) ./conf/dadder.config $(1)/etc/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/badip.txt $(1)/etc/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/blacklist.txt $(1)/etc/
endef


# This line executes the necessary commands to compile our program.
# The above define directives specify all the information needed, but this
# line calls BuildPackage which in turn actually uses this information to
# build a package.
$(eval $(call BuildPackage,dns-holdon))
