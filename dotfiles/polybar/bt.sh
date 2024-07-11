#!/bin/sh

bt_status=$(bluetoothctl show | grep Powered | grep -o "yes\|no")

if [ "$bt_status" = "no" ]; then
	bluetoothctl power on

else
	bluetoothctl power off


fi
