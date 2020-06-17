#===============================================================================
# Setup
#===============================================================================

#---------------------------------------
# Safety checks
#---------------------------------------

# Only load this file once
[[ -n $BASH_PROFILE_SOURCED ]] && return
BASH_PROFILE_SOURCED=true


#---------------------------------------
# Environment checks
#---------------------------------------

# $USER is not set inside Docker
if [[ -z ${USER:-} ]]; then
    export USER=$(whoami)
fi

#---------------------------------------
# Path
#---------------------------------------

# Note: The ones lower down take precedence
PATH="$HOME/go/bin:$PATH"
PATH="$HOME/.rvm/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"

PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="$HOME/.composer/vendor/bin:$PATH"
PATH="$HOME/.composer/packages/vendor/bin:$PATH"

PATH="$HOME/.bin:$PATH"

# For tab completion with sudo
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"

export PATH


#---------------------------------------
# Umask
#---------------------------------------

if [[ $(umask) = 0000 ]]; then
    if is-root-user; then
        umask 022
    else
        umask 002
    fi
fi


#===============================================================================
# Settings
#===============================================================================

export EDITOR='vim'
export GEDITOR="$EDITOR"
export LESS='FRX'
export LS_COLORS='rs=0:fi=01;37:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'
export PAGER='less'
export PGDATABASE='postgres'
export VISUAL="$EDITOR"

if [ -z "$DISPLAY" ] && is-wsl; then
    export DISPLAY='localhost:0.0'
fi

# Stop Perl complaining on cPanel servers
# I did set in MinTTY, but it's not picked up
# Using en_US instead of en_GB to stop Vim and less complaining
if [[ ${LANG:-} = 'C.UTF-8' ]]; then
    export LANG='en_US.UTF-8'
fi

if [ -z "$XAUTHORITY" ]; then
    export XAUTHORITY="$HOME/.Xauthority"
fi


#---------------------------------------
# SSH agent
#---------------------------------------

# wsl-ssh-pageant - https://github.com/benpye/wsl-ssh-pageant
if is-wsl; then
    temp=$(wsl-temp-path)
    if [ -f "$temp/wsl-ssh-pageant.sock" ]; then
        export SSH_AUTH_SOCK="$temp/wsl-ssh-pageant.sock"
    fi
fi

# Workaround for losing SSH agent connection when reconnecting tmux
# It doesn't work on WSL, but isn't necessary when using wsl-ssh-pageant
if ! is-wsl; then
    link="$HOME/.ssh/ssh_auth_sock"
    if [[ $SSH_AUTH_SOCK != $link ]] && [[ -S $SSH_AUTH_SOCK ]]; then
        ln -nsf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
    fi
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
fi


#---------------------------------------
# Local settings / functions
#---------------------------------------

[[ -f ~/.bash_profile_local ]] && source ~/.bash_profile_local


#===============================================================================
# Interactive shells
#===============================================================================

# Use .bashrc for interactive shell settings
source ~/.bashrc
