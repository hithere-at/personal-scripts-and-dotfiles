#!/bin/sh

# args: $1 = input
#       $2 = lower range
#       $2 = upper range
int_sanitize() {
	if [ $1 -eq $1 2> /dev/null ] && [ $1 -ge $2 ] && [ $1 -le $3 ]; then
		return 0

	else
		return 1

	fi

}

# args: $1 = prompt msg
#       $2 = int lower range (optional)
#       $3 = int upper range (optional)
prompt() {

	while true; do
		printf "$1"
		read a

		[ -z "$a" ] && printf "\nInput cannot be empty\n"

		if ! [ -z $2 ] && ! [ -z $3 ]; then
			int_sanitize "$a" $2 $3
			err=$?

			case  $err in
				1) printf "\nInvalid integer input\n";;
				0) break;;

			esac

		fi

		break

	done

	INPUT="$a"

}

extra_packages=""

printf "\nWARNING: YOU NEED TO CREATE, FORMAT, AND MOUNT THE PARTITIONS BY YOURSELF.\n"

prompt "\nWhat username do you want to use\n>> "
username="$INPUT"

prompt "\nWhat hostname do you want to use\n>> "
hostname="$INPUT"

prompt "\nDo you have Intel or AMD CPU?\n1. Intel\n2. AMD\n>> " 1 2
cpu="$INPUT"

while true; do
	prompt "\nYou have to set the timezone manually, please enter your timezone listed by the command 'timedatectl list-timezones'\n>> "
	timezone="$INPUT"

	if [ -f "/usr/share/zoneinfo/${timezone}" ]; then
		break

	else
		printf "Timezone doesnt exist, please try again\n"
		continue

	fi

done

prompt "\nPlease choose one of the available session\n1. Plasma X11\n2. bspwm\n>> " 1 2
session="$INPUT"

if [ $session -eq 2 ]; then
	prompt "\nDo you want to setup autologin?\n1. Yes\n2. No\n>> " 1 2
	autologin="$INPUT"

	prompt "\nDo you want a pre-configured bspwm setup?\n1. Yes\n2. No>> " 1 2
	preconfigured="$INPUT"

fi

printf "\nInstalling essential packages...\n"

if [ $session -eq 1 ];then
	extra_packages="${extra_packages} plasma-desktop plasma-pa sddm breeze-gtk kde-gtk-config kdeconnect sddm-kcm xdg-desktop-portal xdg-desktop-portal-kde"

elif [ $session -eq 2 ]; then
	extra_packages="${extra_packages} bspwm sxhkd polybar xdg-desktop-portal qt5ct kitty feh picom cava"

fi

if [ $cpu -eq 1 ]; then
	extra_packages="${extra_packages} intel-ucode"
	ucode_file="intel-ucode.img"

elif [ $cpu -eq 2 ]; then
	extra_packages="${extra_packages} amd-ucode"
	ucode_file="amd-ucode.img"

fi

yes | pacstrap -K /mnt base base-devel linux-firmware linux-headers linux sudo nano wget networkmanager fuse xorg-server xorg-xrandr pipewire exfatprogs man-pages man-db texinfo mesa noto-fonts noto-fonts-cjk noto-fonts-emoji pipewire pipewire-jack pipewire-alsa pipewire-pulse pipewire-audio xorg-xprop xorg-xinit xorg-xsetroot neofetch xdg-user-dirs $extra_packages

printf "\nGenerating fstab...\n"
genfstab -U /mnt >> /mnt/etc/fstab

printf "\nModifying ext4 partition mount options...\n"
sed -i "s/ext4\(.*\)rw,relatime/ext4\1defaults,noatime,commit=60/g" /mnt/etc/fstab

printf "\nConfiguring system...\n"

arch-chroot /mnt ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo -e 'LANG=en_US.UTF-8\n' > /etc/locale.conf
arch-chroot /mnt echo -e 'KEYMAP=us\n' > /etc/vconsole.conf
arch-chroot /mnt echo "${hostname}\n" > /etc/hostname

printf "\nConfiguring boot loader\n"

root_uuid=$(grep '/ ' /mnt/etc/fstab | grep -o 'UUID=[^[:space:]]*' | sed 's/UUID=//')

arch-chroot /mnt bootctl install
arch-chroot /mnt echo -e 'timeout 5\nconsole-mode max\nloader arch.conf\n' > /mnt/boot/loader/loader.conf
arch-chroot /mnt echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /${ucode_file}\ninitrd /initramfs-linux.img\noptions root=\"UUID=${root_uuid}\" rw\n" > /mnt/boot/loader/entries/arch.conf
arch-chroot /mnt echo -e "title Arch Linux (fallback)\nlinux /vmlinuz-linux\ninitrd /${ucode_file}\ninitrd /initramfs-linux-fallback.img\noptions root=\"UUID=${root_uuid}\" rw\n" > /mnt/boot/loader/entries/arch-fallback.conf

printf "\nConfiguring users...\n"

arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
arch-chroot /mnt useradd -m -G wheel -s /usr/bin/bash ${username}

printf "\nPlease set the password for user '$username'\n"
arch-chroot /mnt passwd ${username}

printf "\nPlease set the password for root user"
arch-chroot /mnt passwd

umount -R /mnt

printf "\nEnabling essential systemd unit\n"
systemctl enable NetworkManager.service --root=/mnt
systemctl enable pipewire-pulse.service --root=/mnt

printf "\nCreating XDG user directories...\n"
arch-chroot -u $username xdg-user-dirs-update

if [ $session -eq 1 ]; then
	printf "\nEnabling SDDM...\n"
	systemctl enable sddm.service --root=/mnt

fi

if [ $session -eq 2 ]; then
	printf "\nConfiguring bspwm...\n"
	arch-chroot -u $username /mnt mkdir -p /home/$username/.config/bspwm /home/$username/.config/sxhkd

	if [ $preconfigured -eq 1 ]; then
		cp -r ../dotfiles/* /mnt/home/$username/.config
		arch-chroot -u $username /mnt chown -R $username:$username /home/$username/.config/*

		printf "\nInstalling JetBrainsMono nerd fonts...\n"

		arch-chroot -u $username /mnt mkdir -p /home/$username/.local/share/fonts
		arch-chroot -u $username /mnt wget -P /home/$username/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf
		arch-chroot -u $username /mnt wget -P /home/$username/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Bold/JetBrainsMonoNerdFontMono-Bold.ttf
		arch-chroot -u $username /mnt wget -P /home/$username/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Italic/JetBrainsMonoNerdFontMono-Italic.ttf
		arch-chroot -u $username /mnt wget -P /home/$username/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/BoldItalic/JetBrainsMonoNerdFontMono-BoldItalic.ttf
		arch-chroot -u $username /mnt wget -P /home/$username/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Medium/JetBrainsMonoNerdFont-Medium.ttf

	elif [ $preconfigured -eq 2 ]; then
		arch-chroot -u $username /mnt install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc /home/$username/.config/bspwm/bspwmrc
		arch-chroot -u $username /mnt install -Dm755 /usr/share/doc/bspwm/examples/sxhkdrc /home/$username/.config/sxhkd/sxhkdrc

	fi

	if [ $autologin -eq 1 ]; then
		arch-chroot /mnt mkdir /etc/systemd/system/getty@tty1.service.d
		arch-chroot /mnt echo -e echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty -o '-p -f -- \\\\\u' --keep-baud --autologin $username 115200,57600,38400,9600 - \$TERM" > /etc/systemd/system/getty@tty1.service.d/autologin.conf

	fi

	arch-chroot -u $username /mnt cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
	arch-chroot -u $username /mnt echo -e "\nxsetroot -cursor_name left_ptr\nbspwm\n" >> /home/$username/.xinitrc
	arch-chroot -u $username /mnt echo -e '#!/bin/sh\n\nexec /usr/bin/Xorg -nolisten tcp "$@" vt$XDG_VTNR\n' > /home/$username/.xserverrc
	arch-chroot -u $username /mnt echo -e '\nif [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then\n    exec startx\nfi\n' >> /home/$username/.bash_profile

fi

printf "\nAll done. You may now reboot your system. It is highly recommended to run 'xdg-user-dirs-update' and installing a firewall after rebooting to your system\n"
