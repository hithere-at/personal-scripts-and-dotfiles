#!/bin/sh
a=$(pgrep -x picom)

if [ -z "$a" ]; then
	picom -b

else
	killall picom

fi
