#!/bin/sh

printf "Please choose one of the action listed below..\n1. Shutdown\n2. Reboot\n3. Logout\n>> "
read action

if [ $action -eq 1 ]; then
	poweroff

elif [ $action -eq 2 ]; then
	reboot

elif [ $action -eq 3 ]; then
	bspc quit

fi
