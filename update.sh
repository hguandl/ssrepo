#!/bin/bash

DIR=feeds.nosync

PKGS=(openwrt-shadowsocks luci-app-shadowsocks)
FEED_BASE=(mbedtls)
FEED_PKGS=(libcares libsodium pcre libev)

update() {
    if [ ! -d $DIR/$1 ]; then
        git clone https://github.com/shadowsocks/$1.git $DIR/$1
    else
        pushd $DIR/$1
        git pull
        popd
    fi
}

sync() {
    rsync -av --exclude=.git $1 .
}

update openwrt-feeds
update openwrt-shadowsocks
update luci-app-shadowsocks

for pkg in ${PKGS[*]}; do
    sync $DIR/$pkg
done

for pkg in ${FEED_BASE[*]}; do
    sync $DIR/openwrt-feeds/base/$pkg
done

for pkg in ${FEED_PKGS[*]}; do
    sync $DIR/openwrt-feeds/packages/$pkg
done
