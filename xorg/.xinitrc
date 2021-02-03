#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)
setxkbmap -model thinkpad -layout es &

# invoke global X session script
. /etc/X11/Xsession &

## exec WM
#xrdb $HOME/.Xresources &

# $HOME/.fehbg &
# sxhkd &
# dwmblocks &
exec dwm
#/usr/bin/emacs --daemon &

# exec bspwm
