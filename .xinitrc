#!/bin/sh

if [ -f ~/.Xresources ]; then
  xrdb -merge -I$HOME ~/.Xresources
fi

numlockx &

exec i3

xset s off
xset -dpms
