#!/bin/bash

DIR=feeds.nosync

PKGS=(openwrt-shadowsocks luci-app-shadowsocks openwrt-chinadns openwrt-dns-forwarder openwrt-dist-luci)
FEED_BASE=(mbedtls)
FEED_PKGS=(libcares libsodium pcre libev)

update() {
    if [ ! -d $DIR/$2 ]; then
        git clone https://github.com/$1/$2.git $DIR/$2
    else
        pushd $DIR/$2
        git pull
        popd
    fi
}

sync() {
    rsync -av --exclude=.git $1 .
}

update shadowsocks openwrt-feeds
update shadowsocks openwrt-shadowsocks
update shadowsocks luci-app-shadowsocks

update aa65535 openwrt-chinadns
update aa65535 openwrt-dns-forwarder
update aa65535 openwrt-dist-luci
update pymumu smartdns

for pkg in ${PKGS[*]}; do
    sync $DIR/$pkg
done

for pkg in ${FEED_BASE[*]}; do
    sync $DIR/openwrt-feeds/base/$pkg
done

for pkg in ${FEED_PKGS[*]}; do
    sync $DIR/openwrt-feeds/packages/$pkg
done

rsync -av --exclude=.git $DIR/smartdns/package/openwrt/ ./smartdns/