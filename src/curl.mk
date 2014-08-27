# This file is part of MXE.
# See index.html for further information.

PKG             := curl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.37.0
$(PKG)_CHECKSUM := 0bcd1bd7901ee1d7059189d2b3807fdb6a271bc6
$(PKG)_SUBDIR   := curl-$($(PKG)_VERSION)
$(PKG)_FILE     := curl-$($(PKG)_VERSION).tar.lzma
$(PKG)_URL      := http://curl.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc polarssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-nghttp2 \
        --without-libidn \
        --without-winidn \
        --without-libssh2 \
        --without-librtmp \
        --without-libmetalink \
        --without-axtls \
        --without-nss \
        --without-cyassl \
        --without-ssl \
        --without-gnutls \
        --disable-gopher \
        --disable-smtp \
        --disable-imap \
        --disable-pop3 \
        --disable-tftp \
        --disable-telnet \
        --disable-dict \
        --disable-proxy \
        --disable-rtsp \
        --disable-ldaps \
        --disable-ldap \
        --disable-file \
        --disable-ftp \
        --enable-http \
        --enable-shared=no \
        --enable-static=yes \
        --with-polarssl=$(PREFIX)/$(TARGET) \
        --without-ca-bundle \
        --without-ca-path

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/curl-config' '$(PREFIX)/bin/$(TARGET)-curl-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-curl.exe' \
        `'$(TARGET)-pkg-config' libcurl --cflags --libs`
endef
