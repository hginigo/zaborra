#!/bin/sh
# Script to quickly configure my setup for Debian based distros
# This script is intended to be used in a Debian distro, it is
# only been tested on Debian testing, and may not work propely
# on other distributions.
# TODO: install sudo automatically lmao
[ -z sudo ] && echo "Do you have sudo installed?\nExiting..." && exit 1
echo "Exiting..."
exit 0

# Setup the XDG Base Directory specification
#sudo sed -i '/^if *\[ *.*id -u.*\]; *then$/a\
sudo sed -i '/^else$/a\
  export XDG_CONFIG_HOME="$HOME/.config"\
  export XDG_CACHE_HOME="$HOME/.cache"\
  export XDG_DATA_HOME="$HOME/.local/share"' /etc/profile

# Add contrib and non-free repos to apt
sudo sed -i 's/^deb.*main$/& contrib non-free/' /etc/apt/sources.list

# Add the wheel group systemwide
sudo sed -i '/^\# auth *required *pam_wheel.so$/s/^..//' /etc/pam.d/su
sudo addgroup --system wheel

# Add user to the following groups
sudo adduser "$USER" sudo
sudo adduser "$USER" wheel

# Install some basic programs from apt
sudo apt-get update
sudo apt-get install\
	build-essential\
	firmware-iwlwifi\
	network-manager\
	fontconfig\
	fonts-inconsolata\
	fonts-mononoki\
	fonts-ubuntu\
	fonts-ubuntu-console\
	zip\
	wget\
	curl\
	rfkill\
	nnn\
	vim\
	neovim\
	emacs\
	git\
	isync\
	mu4e\
	openssl\
	gnupg2\
	xorg\
	arandr\
	scrot\
	alsa-utils\
	feh\
	bspwm\
	sxhkd\
	redshift\
	xdotool\
	sysstat\
	calc\
	zathura\
	mpv\
	thunar\
	chromium\
	r-base\
	tldr\
	libssl-dev\
	imagemagick\
	info\
	htop\
        libxinerama-dev

# Update fonts list
fc-cache

# Helper function to install custom programs
Inst () {
	OLD_DIR="$(pwd)"
	cd "$1"
	sudo make install
	cd "$OLD_DIR"
}

# Install some custom builds of programs
Inst "$HOME/builds/st-0.8.4/"
Inst "$HOME/dmenu-5.0/"
Inst "$HOME/lemonbar-xft/"
Inst "$HOME/pfetch/"
#Inst "$HOME/isync-1.3.3/"

# Enable NetworkManager module for systemd
sudo systemctl enable NetworkManager

# Block bluetooth
sudo rfkill block 0

echo "Done."
read -p "Reboot now? (Required to enable wifi) [y/n] " CONFIRM
[ -z "$CONFIRM" -o "$CONFIRM" != "n" ]\
	&& (echo "Rebooting now..." && sudo reboot now)\
	|| (echo "Exiting...")
exit 0
