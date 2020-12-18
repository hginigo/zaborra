# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

## EXPORTS
# export cargo for rust 
export PATH="$HOME/.cargo/bin:$PATH"
# export julia path
export PATH="$PATH:$HOME/builds/julia-1.5.2/bin"
# export pyenv for managing multiple python versions
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# startx automatically
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
	. startx
	logout
fi

