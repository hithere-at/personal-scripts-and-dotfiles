# dotfiles and scripts
This is my collection of scripts and dotfiles that i used. This thing exist because i dont want reconfigure my system when my laptop decided to break itself. Feel free to use this however you want

## Preview
![Desktop screenshot](media/sc1.png)
![Desktop screenshot alt](media/sc2.png)

## Features
- Basic hardware status (battery, brightness, volume)
- Animations. No more weird picom forks
- Material you based color scheme
- Sleek
- Widgets with eww

## Requirements

### Fonts
- JetBrainsMono Nerd Font Mono (Regular, Bold, Italic, Bold Italic)
- JetBrainsMono Nerd Font (Medium)
- CascadiaMono Nerd Font (Regular)
- Noto Fonts Mono

### Miscellaneous
- Nano syntax highlighting plugins
- ZSH shift select plugins
- ZSH syntax highlighting plugins

### Apps
- alacritty
- bspwm
- btop
- cava
- dunst
- eww
- picom
- rofi
- spectacle
- sxhkd
- zsh

## Notes
- This theme is derived from [marian](https://github.com/hithere-at/personal-scripts-and-dotfiles/tree/marian) theme, but with UI changes.
- Animations for window geometry changes configurations are taken from [gh0stzk/dotfiles](https://github.com/gh0stzk/dotfiles) with modified curve.
- Workspace widget script is takne from [raexera/tokyo](https://github.com/raexera/tokyo)
- CPU temperature script is located on scripts/cputemp. You must build it yourself and put the resulting binary in ~/.config/eww/poller if you want temperature monitoring.
- You need to install this dotfiles manually, and some configurations may not work out of the box (e.g sxhkd, bspwm). Some of the configuration needs to be edited to suit your PC, like the width of the bar.
