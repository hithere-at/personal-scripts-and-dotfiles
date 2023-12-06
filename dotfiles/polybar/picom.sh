#!/bin/sh

a=$(pgrep -x picom)

if [ -z "$a" ]; then
	picom --unredir-if-possible --blur-background --backend glx --xrender-sync-fence --blur-method dual_kawase --use-damage --vsync -I 1 -O 1 -D 0 -b

else
	killall picom

fi
