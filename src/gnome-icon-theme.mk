# This file is part of MXE.
# See index.html for further information.

PKG             := gnome-icon-theme
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.12.0
$(PKG)_CHECKSUM := cc0f0dc55db3c4ca7f2f34564402f712807f1342
$(PKG)_SUBDIR   := gnome-icon-theme-$($(PKG)_VERSION)
$(PKG)_FILE     := gnome-icon-theme-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/gnome-icon-theme/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-icon-mapping=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

endef
