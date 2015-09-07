# This file is part of MXE.
# See index.html for further information.

PKG             := gtk3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.14.15
$(PKG)_CHECKSUM := f9512273f17907c6e2d0b73f81529b7a798caf47
$(PKG)_SUBDIR   := gtk+-$($(PKG)_VERSION)
$(PKG)_FILE     := gtk+-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtk+/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libpng jpeg tiff jasper glib atk pango cairo gdk-pixbuf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/gtk+/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9]*\.[0-9]*[02468]\.[^<]*\)<.*,\1,p' | \
    grep '^3\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf --force --install && \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-win32-backend \
        --disable-gdiplus \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-included-immodules \
        --without-x \
        --enable-static \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk3.exe' \
        `'$(TARGET)-pkg-config' gtk+-3.0 glib-2.0 atk --cflags --libs`
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && autoreconf --force --install && \
        ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-win32-backend \
        --disable-gdiplus \
        --enable-explicit-deps \
        --disable-glibtest \
        --disable-modules \
        --disable-cups \
        --disable-test-print-backend \
        --disable-gtk-doc \
        --disable-man \
        --with-included-immodules \
        --without-x \
        --enable-shared \
        --disable-static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gtk3.exe' \
        `'$(TARGET)-pkg-config' gtk+-3.0 gmodule-2.0 atk --cflags --libs`
endef
