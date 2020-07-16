#!/bin/sh

SUDO=''
if [ $EUID -ne 0 ]; then
  SUDO='sudo'
fi

$SUDO pacman -Syu
$SUDO pacman -Sy privoxy
DD_FLAGS="oflag=append conv=notrunc"
echo "forward-socks5t / 127.0.0.1:1080 ." | $SUDO dd $DD_FLAGS of=/etc/privoxy/config
echo "listen-address 127.0.0.1:1087" | $SUDO dd $DD_FLAGS of=/etc/privoxy/config
