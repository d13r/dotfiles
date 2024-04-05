#===============================================================================
# Part of Dave James Miller's dotfiles - https://github.com/d13r/dotfiles
# To uninstall: source ~/.dotfiles/uninstall
#===============================================================================

#
# This file is executed every time Bash is loaded, even if it is NOT an interactive session
#
# Also see: .bashrc
#

#===============================================================================
# Setup
#===============================================================================

#---------------------------------------
# Safety checks
#---------------------------------------

# Only load this file once
[[ -n $BASH_PROFILE_SOURCED ]] && return
BASH_PROFILE_SOURCED=true

# Prevent errors if $HOME is not set (e.g. Proxmox after running Upgrade)
[[ -z $HOME ]] && return


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
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

PATH="$HOME/go/bin:$PATH"
PATH="$HOME/.local/bin:$PATH" # pip (and perhaps others)
PATH="$HOME/.rvm/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"

PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="$HOME/.composer/vendor/bin:$PATH"
PATH="$HOME/.composer/packages/vendor/bin:$PATH"

PATH="$HOME/.bin:$PATH"
PATH="$HOME/.bin/local:$PATH"

if is-wsl; then
    # Note: Can't use aliases because they interfere with _complete_alias
    PATH="$HOME/.bin/windows:$PATH"
    PATH="$HOME/.bin/local/windows:$PATH"
fi

# For tab completion with sudo
PATH="$PATH:/usr/local/sbin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/sbin"

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
export GEDITOR=$EDITOR
export LESS='FRX'

if is-mac; then
    export LSCOLORS='DxGxFxDaCaDaDahbaDacec'
else
    # https://askubuntu.com/a/1042242/29806
    # Also see .gitconfig
    export GREP_COLORS='ms=91:mc=91:sl=:cx=:fn=35:ln=32:bn=32:se=36'
    export LS_COLORS='rs=0:fi=97:di=93:ln=96:mh=00:pi=40;33:so=95:do=95:bd=40;93:cd=40;93:or=40;91:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=92'
fi

export PAGER='less'
export PGDATABASE='postgres'
export VISUAL=$EDITOR

if [[ -z $DISPLAY ]]; then
    if is-wsl 1; then
        export DISPLAY='localhost:0'
    elif is-wsl 2; then
        # https://blog.nimamoh.net/wsl2-and-vcxsrv/
        export DISPLAY="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0"
    fi
fi

if [[ -z $XAUTHORITY ]]; then
    # https://forum.snapcraft.io/t/x11-forwarding-using-ssh/2381/8
    export XAUTHORITY=$HOME/.Xauthority
fi

# Stop Perl complaining on cPanel servers
# I did set in MinTTY, but it's not picked up
# Using en_US instead of en_GB to stop Vim and less complaining
# Removed 18 Feb 2023 because MI servers complain about en_US, while WSL complains about en_GB
#if [[ ${LANG:-} = 'C.UTF-8' ]] && locale -a | grep en_US.utf8 >/dev/null; then
#    export LANG='en_US.UTF-8'
#    export LC_ALL='en_US.UTF-8'
#fi


#---------------------------------------
# SSH agent
#---------------------------------------

if is-wsl 1; then

    # wsl-ssh-pageant - https://github.com/benpye/wsl-ssh-pageant
    if [[ ! -f ~/.ssh/wsl-ssh-pageant.exe ]]; then
        echo
        style lblue 'Downloading wsl-ssh-pageant...'
        curl -L 'https://github.com/benpye/wsl-ssh-pageant/releases/download/20201121.2/wsl-ssh-pageant-amd64.exe' > ~/.ssh/wsl-ssh-pageant.exe
    fi

    temp=$(wsl-temp-path)
    export SSH_AUTH_SOCK="$temp/wsl-ssh-pageant.sock"

    if [[ $(tasklist.exe /FI "IMAGENAME EQ wsl-ssh-pageant.exe" /FO CSV | tail +2 | wc -l) -eq 0 ]]; then
        rm -f "$temp/wsl-ssh-pageant.exe" "$SSH_AUTH_SOCK" 2>/dev/null && \
            cp ~/.ssh/wsl-ssh-pageant.exe "$temp/wsl-ssh-pageant.exe"

        # This is a bit convoluted, but if wsl-ssh-pageant.exe is started as a
        # sub-process then as soon as WSL is closed it jumps to 100% CPU. This
        # way it runs outside the WSL process tree, so it keeps working.
        temp_win=$(wslpath -w "$temp")
        cmd.exe /c start /b "$temp_win\\wsl-ssh-pageant.exe" --force --wsl "$temp_win\\wsl-ssh-pageant.sock" &>/dev/null
    fi

elif is-wsl 2; then

    # wsl2-ssh-pageant - https://github.com/BlackReloaded/wsl2-ssh-pageant
    if [[ ! -f ~/.ssh/wsl2-ssh-pageant.exe ]]; then
        echo
        style lblue 'Downloading wsl2-ssh-pageant...'
        curl -L 'https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.4.0/wsl2-ssh-pageant.exe' > ~/.ssh/wsl2-ssh-pageant.exe
    fi

    if [[ -f ~/.ssh/wsl2-ssh-pageant.exe ]]; then
        chmod +x ~/.ssh/wsl2-ssh-pageant.exe
        export SSH_AUTH_SOCK="$HOME/.ssh/wsl2-ssh-pageant.sock"
        if ! is-executable socat; then
            echo
            style lblue 'Installing socat for wsl2-ssh-pageant...'
            sudo apt-get install socat
        fi
        fuser -k "$SSH_AUTH_SOCK" &>/dev/null
        rm -f "$SSH_AUTH_SOCK"
        setsid --fork nohup socat "UNIX-LISTEN:$SSH_AUTH_SOCK,fork" "EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe" &>/dev/null
    fi

fi

# This is used by terminal-for-x2go, and can also be used interactively
share-ssh-agent() {
    local socket

    for socket in \
        "$SSH_AUTH_SOCK" \
        $(find /run/user -user $(id -u) -iregex /run/user/[0-9]+/keyring/ssh -type s 2>/dev/null) \
        $(find /tmp -user $(id -u) -iregex /tmp/ssh-[a-zA-Z0-9]+/agent.[0-9]+ -type s 2>/dev/null)
    do
        echo "Checking $socket..."
        if SSH_AUTH_SOCK=$socket timeout 10 ssh-add -l &>/dev/null; then
            export SSH_AUTH_SOCK=$socket
            echo "Using $socket"
            echo
            ssh-add -l
            return
        fi
    done

    echo 'No valid SSH agents found' >&2
    return 1
}

#---------------------------------------
# SSH config
#---------------------------------------

# No longer used (27 Jan 2023)
rm -f ~/.ssh/config_dynamic


#---------------------------------------
# Custom settings / functions
#---------------------------------------

# Local settings, not committed to Git
[[ -f ~/.bash_profile_local ]] && source ~/.bash_profile_local


#===============================================================================
# Interactive shells
#===============================================================================

# Use .bashrc for interactive shell settings
source ~/.bashrc
