#!/bin/sh

focused_window=$(xdotool getactivewindow)
focused_winprop="$(xprop -id $focused_window)"
focused_class="$(echo $focused_winprop | grep WM_CLASS | grep -o Alacritty | head -n 1)"

echo -e "$focused_window\n$focused_winprop\n$focused_class"

if [ "$focused_class" = "Alacritty" ]; then
    focused_pid=$(xprop -id $focused_window _NET_WM_PID | grep -o '[0-9]\+')

    if [ -z $focused_pid ]; then
        alacritty
        exit

    fi

    focused_shell_pid=$(pgrep -P $focused_pid)
    focused_cwd="$(readlink /proc/$focused_shell_pid/cwd)"

    alacritty --working-directory $focused_cwd

else
    alacritty

fi

