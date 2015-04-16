# This file is part of MXE.
# See index.html for further information.

PKG             := quazip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7
$(PKG)_CHECKSUM := 861ab4efc048fdb272161848bb8829848857ec97
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.sourceforge.net/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qtbase zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/quazip/files/quazip/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
        cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
            PREFIX='$(PREFIX)/$(TARGET)' DEFINES+=QUAZIP_STATIC LIBS+=-lz,
        cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' \
            PREFIX='$(PREFIX)/$(TARGET)' LIBS+=-lz)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
