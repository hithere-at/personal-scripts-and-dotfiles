#!/bin/sh

a=$(pgrep -x compfy)

if [ -z "$a" ]; then
	compfy -b

else
	killall compfy

fi
