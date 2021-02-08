
export TERM="xterm-256color"
export EDITOR="vim"
export VISUAL="emacs"
export GIT_EDITOR="vim"

## SET VI MODE
#set -o vi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## PROMPT
bold=$(tput bold)
norm=$(tput sgr0)
PS1='\[${bold}\]\[\033[91m\]\u@\h:\[\033[97m\]\W\[\033[0m\]\[${norm}\]\$ '

# set PROMPT_COMMAND
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

## PATH
if [ -d "$HOME/.scripts" ] ;
	then PATH="$HOME/.scripts:$PATH"
fi

## EXTRACTING SHORTCUT
ex()
{
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xjf	$1	;;
			*.tar.gz)	tar xzf	$1	;;
			*.bz2)		bunzip2	$1	;;
			*.rar)		unrar x	$1	;;
			*.gz)		gunzip	$1	;;
			*.tar)		tar xf	$1	;;
			*.tbz2)		tar xjf	$1	;;
			*.tgz)		tar xzf	$1	;;
			*.zip)		unzip	$1	;;
			*.Z)	uncompress	$1	;;
			*.7z)		7z x	$1	;;
			*.deb)		ar x	$1	;;
			*.tar.xz)	tar xf	$1	;;
			*.tar.zst)	unzstd	$1	;;
			*)		echo "'$1' cannot be extracted via ex" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

## SOURCES
#source ~/.profile

## ALIASES

# cd
# alias alacritty='LIBGL_ALWAYS_SOFTWARE=1 alacritty'
alias ..='cd ..'
alias ...='cd ../..'
alias uni='cd ~/docs/uni/'

# colorized ls -> exa
if [[ $(exa 2> /dev/null) ]] ; then
	alias ls='exa --color=always'
	alias la='exa -la --color=always'
	alias ll='exa -l --color=always'
else
	alias ls='ls --color=always'
	alias la='ls -la --color=always'
	alias ll='ls -l --color=always'
fi

# colorized grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# confirmation
#alias cp='cp -i'
#alias mv='mv -i'
#alias rm='rm -i'

# neovim
#alias vim='nvim'
#alias vim='nvim'

# pyenv init
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

## NEOFETCH
#neofetch
[ -n pfetch ] && pfetch



