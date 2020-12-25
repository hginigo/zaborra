#!/bin/sh
# Script to quickly configure my setup for Debian based distros

Warning () {
    [ "$1" ] \
        && printf '%s\n' "$1"\
        || printf 'Something went wrong.\n'
}

Error () {
    Warning "$1"
    exit 1
}

# Some global variables
[ -z "$dotfiles" ] && dotfiles="https://github.com/hginigo/zaborra.git"
[ -z "$branch" ] && branch="master"
[ "$USER" != 'root' ] \
    && user="$USER"\
    || Error "You must not execute this script as root"

# Home is changed to /root when using sudo
home="/home/$user"
destdir="$home/.local/builds"

# Helper functions to install custom programs
GitInst () {
    gitname="$(basename "$1" .git)"
    gitdir="$([ "$3" ] && echo "$3" || echo "$destdir")/$gitdir"
    gitbranch=$([ "$2" ] && echo "$2" || echo "$branch")
    printf "Installing %s " "$gitname"
    git clone "$1" "$gitdir" >/dev/null 2>&1
    cd "$gitdir" || { Warning "Could not clone $gitname."; return 1; }
    git checkout "$gitbranch" >/dev/null 2>&1\
        || Warning "\nCould not change to branch $gitbranch. Trying to install from master."
    { make clean >/dev/null 2>&1 ; make install >/dev/null 2>&1; }\
        || Warning "\nCould not install $gitname"\
        && printf "Done.\n"
    return 0
}

SetupDotfiles () {
    gitname="$(basename "$1" .git)"
    gitdir="$([ "$3" ] && echo "$3" || echo "$destdir")/$gitdir"
    gitbranch=$([ "$2" ] && echo "$2" || echo "$branch")
    printf "Setting up dotfiles %s " "$gitname"
    git clone "$1" "$gitdir" >/dev/null 2>&1 
    cd "$gitdir" || Error
    git checkout "$gitbranch" >/dev/null 2>&1\
        || Warning "\nCould not change to branch $gitbranch. Trying to install from master."
    [ "$(command -v stow)" ] \
        && stow -- *glob*\
        || Warning "\nCould not set up dotfiles $gitname"; return 1
    printf "Done.\n"
}

## BEGINNING OF THE SCRIPT
# Try to install sudo
apt install sudo >/dev/null 2>&1 || Error "Are you su and have an internet connection?"

Error
echo "Exiting..."
exit 0

# Setup the XDG Base Directory specification
sed -i '/^else$/a\
  export XDG_CONFIG_HOME="$HOME/.config"\
  export XDG_CACHE_HOME="$HOME/.cache"\
  export XDG_DATA_HOME="$HOME/.local/share"' /etc/profile

# Add contrib and non-free repos to apt
sed -i 's/^deb.*main$/& contrib non-free/' /etc/apt/sources.list

# Add the wheel group systemwide
sed -i '/^\# auth *required *pam_wheel.so$/s/^..//' /etc/pam.d/su
sudo addgroup --system wheel

# Add user to the following groups
sudo adduser "$user" sudo
sudo adduser "$user" wheel

# Install some basic programs from apt
apt-get update >/dev/null 2>&1
apt-get install\
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
        stow\
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
        libxinerama-dev\
        >/dev/null 2>&1

# Update fonts list
fc-cache

# Install some custom builds or programs
GitInst "https://git.suckless.org/dmenu"
GitInst "https://git.suckless.org/st"
GitInst "https://github.com/dylanaraps/pfetch.git"
# GitInst "https://github.com/hginigo/dwm" "custom"
GitInst "https://git.suckless.org/dwm"
# GitInst "https://github.com/hginigo/dwmblocks" "custom"
SetupDotfiles "$dotfiles"

# Enable NetworkManager module for systemd
sudo systemctl enable NetworkManager

echo "Done."
printf "Reboot now? (Required to enable wifi) [y/n] "
read -r confirm
\( [ -z "$confirm" ] || [ "$confirm" != "n" ] \) \
	&& { echo "Rebooting now..."; reboot now; }\
	|| { echo "Log back in for changes to take effect."; }
exit 0
