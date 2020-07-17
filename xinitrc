#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# user customize

# refresh rate
if [ $1 != "--vnc" ]; then
    xrandr --output DP-0 --mode 1920x1080 --refresh 144
fi

# input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

# map keyboard
xmodmap $HOME/.Xmodmap

# set desktop background color
xsetroot -solid grey

# set desktop background
feh --bg-fill --randomize $HOME/Desktop/* &

# start dbus
export $(dbus-launch)

# start fcitx
fcitx -d

# start pulseaudio
while pulseaudio --check; do
    pulseaudio -k
    pulseaudio --start
done
pasystray &

export TERMINAL=termite
export XKL_XMODMAP_DISABLE=1
export PATH=$PATH:$HOME/.bin

exec i3
