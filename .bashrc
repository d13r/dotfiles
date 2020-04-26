#===============================================================================
# Safety checks
#===============================================================================

# Only load once
[[ -n $BASHRC_LOADED ]] && return
BASHRC_LOADED=true

# Only load in interactive shells
[[ -t 0 ]] || return

# Skip when running a command like 'tmux' or 'gitolite'
[[ -z "${BASH_EXECUTION_STRING:-}" ]] || return


#===============================================================================
# Third party scripts
#===============================================================================
# Load these first so we can override anything they do

# Google Cloud Shell
[[ -f /google/devshell/bashrc.google ]] && source /google/devshell/bashrc.google

# The Fuck
command -v thefuck &>/dev/null && eval $(thefuck --alias)


#---------------------------------------
# Bash completion
#---------------------------------------

# https://trac.macports.org/ticket/44558#comment:13
shopt -s extglob

# This seems to be loaded automatically on some servers but not on others
[[ -f /etc/bash_completion ]] && source /etc/bash_completion

source $HOME/.bash_completion


#===============================================================================
# Path
#===============================================================================

# Note: The ones lower down take precedence
PATH="$HOME/go/bin:$PATH"
PATH="$HOME/.rvm/bin:$PATH"
PATH="$HOME/.yarn/bin:$PATH"

PATH="$HOME/.config/composer/vendor/bin:$PATH"
PATH="$HOME/.composer/vendor/bin:$PATH"
PATH="$HOME/.composer/packages/vendor/bin:$PATH"

PATH="$HOME/.bin:$PATH"

export PATH


#===============================================================================
# Helper functions
#===============================================================================

# These are in separate files because they are used by other scripts too
source $HOME/.bash/ask.sh
source $HOME/.bash/color.bash

_domain-command() {
    command="$1"
    shift

    # Accept URLs and convert to domain name only
    domain=$(echo "$1" | sed 's#https\?://\([^/]*\).*/#\1#')

    if [[ -n $domain ]]; then
        shift
        command $command "$domain" "$@"
    else
        command $command "$@"
    fi
}

_ls-current-directory() {
    echo
    echo -en "\033[4;1m"
    echo $PWD
    echo -en "\033[0m"
    ls -hF --color=always --hide=*.pyc --hide=*.sublime-workspace
}


#===============================================================================
# User functions
#===============================================================================

cw() {
    if [[ -d /vagrant ]]; then
        c /vagrant
    elif is-wsl; then
        c "$(wsl-mydocs-path)"
    elif [[ -d ~/repo ]]; then
        c ~/repo
    elif [[ -d /home/www ]]; then
        c /home/www
    elif is-root-user && [[ -d /home ]]; then
        c /home
    elif [[ -d /var/www ]]; then
        c /var/www
    else
        c ~
    fi
}

dump-path() {
    echo -e "${PATH//:/\\n}"
}

md() {
    mkdir -p "$1" && cd "$1"
}

status() {
    # Useful for checking the result of the last command (do-something; status)
    local status=$?

    if [[ $status -eq 0 ]]; then
        color bg-lgreen black 'Success'
    else
        color bg-red lwhite "Failed with code $status"
    fi

    return $status
}


#===============================================================================
# Aliases
#===============================================================================

alias a2disconf='maybe-sudo a2disconf'
alias a2dismod='maybe-sudo a2dismod'
alias a2dissite='maybe-sudo a2dissite'
alias a2enconf='maybe-sudo a2enconf'
alias a2enmod='maybe-sudo a2enmod'
alias a2ensite='maybe-sudo a2ensite'
alias acs='apt search'
alias acsh='apt show'
alias addgroup='maybe-sudo addgroup'
alias adduser='maybe-sudo adduser'
alias agi='maybe-sudo apt install'
alias agr='maybe-sudo apt remove'
alias agar='maybe-sudo apt autoremove'
alias agu='maybe-sudo apt update && maybe-sudo apt full-upgrade'
alias agupdate='maybe-sudo apt update'
alias agupgrade='maybe-sudo apt upgrade'
alias apt='maybe-sudo apt'
alias apt-add-repository='maybe-sudo apt-add-repository'

alias b='c -'

alias chmox='chmod'
alias com='composer'
alias cp='cp -i'

alias d='docker'
alias db='docker build'
alias dc='docker-compose'
alias dpkg-reconfigure='maybe-sudo dpkg-reconfigure'
alias dr='docker run'
alias dri='docker run -it'

alias g='git'
alias grep="$(command -v grep-less)" # command -v makes it work with sudo
alias groupadd='maybe-sudo groupadd'
alias groupdel='maybe-sudo groupdel'
alias groupmod='maybe-sudo groupmod'

alias history-time='HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] " history'
alias host='_domain-command host'

alias ide='t ide-helper'

alias l="ls -hFl --color=always --hide=*.pyc --hide=*.sublime-workspace"
alias la="ls -hFlA --color=always --hide=*.pyc --hide=*.sublime-workspace"
alias ls="ls -hF --color=always --hide=*.pyc --hide=*.sublime-workspace"
alias lsa="ls -hFA --color=always --hide=*.pyc --hide=*.sublime-workspace"

alias mfs='art migrate:fresh --seed'

alias nslookup='_domain-command nslookup'

alias php5dismod='maybe-sudo php5dismod'
alias php5enmod='maybe-sudo php5enmod'
alias phpdismod='maybe-sudo phpdismod'
alias phpenmod='maybe-sudo phpenmod'
alias poweroff='maybe-sudo poweroff'
alias pow='maybe-sudo poweroff'
alias pu='phpunit'

alias reboot='maybe-sudo reboot'
alias reload='exec bash -l'
alias rm='rm -i'

alias service='maybe-sudo service'
alias shutdown='maybe-sudo poweroff'
alias snap='maybe-sudo snap'
alias sshstop='ssh -O stop'
alias storm='phpstorm'
alias sudo='sudo ' # Expand aliases
alias s='s '

alias tree='tree -C'

alias u='c ..'
alias uu='c ../..'
alias uuu='c ../../..'
alias uuuu='c ../../../..'
alias uuuuu='c ../../../../..'
alias uuuuuu='c ../../../../../..'

alias ufw='maybe-sudo ufw'
alias updatedb='maybe-sudo updatedb'
alias useradd='maybe-sudo useradd'
alias userdel='maybe-sudo userdel'
alias usermod='maybe-sudo usermod'

alias v='vagrant'

alias watch='watch --color '
alias whois='_domain-command whois'

alias yum='maybe-sudo yum'


#---------------------------------------
# Windows-specific aliases
#---------------------------------------

if is-wsl; then
    alias multipass='multipass.exe'
    alias explorer='explorer.exe'
fi


#===============================================================================
# Configure Bash environment
#===============================================================================

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


#===============================================================================
# Automatic updates
#===============================================================================

# Check what the current revision is
old_head=$(cd; git rev-parse HEAD)

# Catch Ctrl-C - sometimes if GitHub or my internet connection is down I
# need to be able to cancel the update without skipping the rest of .bashrc
trap 'echo' INT

# Run the auto-update
~/.bin/cfg-auto-update

trap - INT

# Reload Bash if any changes were made
# Removed because auto-update now runs in the background
#if [ "$(cd; git rev-parse HEAD)" != "$old_head" ]; then
#    exec bash -l
#fi


#===============================================================================
# MOTD
#===============================================================================

if [[ -n $TMUX ]]; then
    # Show the MOTD inside tmux, since it won't be shown if we load tmux
    # immediately from ssh instead of Bash
    if [[ -f /run/motd.dynamic ]]; then
        cat /run/motd.dynamic
        hr="$(printf "%${COLUMNS}s" | tr ' ' -)"
        echo -e "\033[30;1m$hr\033[0m"
    fi
fi


#===============================================================================
# Key mappings
#===============================================================================

# Couldn't get these working in .inputrc
bind '"\eOC":forward-word'
bind '"\eOD":backward-word'


#===============================================================================
# cd / ls
#===============================================================================

# Remember the last directory visited
_record-last-directory() {
    pwd > ~/.bash_lastdirectory
}

cd() {
    command cd "$@" && _record-last-directory
}

# Detect typos in the cd command
shopt -s cdspell

# c = cd; ls
c() {

    # cd to the given directory
    if [[ $@ != . ]]; then
        # If "." don't do anything, so that "cd -" still works
        # Don't output the path as I'm going to anyway (done by "cd -" and cdspell)
        cd "$@" >/dev/null || return
    fi

    _ls-current-directory

}

# Custom 'ls' colours
export LS_COLORS='rs=0:fi=01;37:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'

# Stop newer versions of Bash quoting the filenames in ls
# http://unix.stackexchange.com/a/258687/14368
export QUOTING_STYLE=literal


#===============================================================================
# Completion
#===============================================================================


# Don't tab-complete an empty line - there's not really any use for it
shopt -s no_empty_cmd_completion

# Ignore case when tab-completing
set completion-ignore-case on


#===============================================================================
# Editor
#===============================================================================

export EDITOR=vim
export GEDITOR=$EDITOR
export VISUAL=$EDITOR


#===============================================================================
# fzf - fuzzy finder
#===============================================================================

# https://github.com/junegunn/fzf
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash

    _fzf_compgen_path() {
        echo "$1"
        command find -L "$1" \
            -name .cache -prune -o \
            -name .git -prune -o \
            -name .hg -prune -o \
            -name .svn -prune -o \
            \( -type d -o -type f -o -type l \) \
            -not -path "$1" \
            -print \
            2>/dev/null \
        | sed 's#^\./##'
    }

    _fzf_compgen_dir() {
        command find -L "$1" \
            -name .cache -prune -o \
            -name .git -prune -o \
            -name .hg -prune -o \
            -name .svn -prune -o \
            -type d \
            -not -path "$1" \
            -print \
            2>/dev/null \
        | sed 's#^\./##'
    }

    export FZF_DEFAULT_COMMAND='
        find -L . \
            -name .cache -prune -o \
            -name .git -prune -o \
            -name .hg -prune -o \
            -name .svn -prune -o \
            \( -type d -o -type f -o -type l \) \
            -print \
            2>/dev/null \
        | sed "s#^./##"
    '

    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

    export FZF_CTRL_T_OPTS="
        --select-1
        --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'
    "

    export FZF_ALT_C_OPTS="
        --preview 'tree -C {} | head -200'
    "

    export FZF_COMPLETION_TRIGGER='#'

    _fzf_setup_completion dir c
    _fzf_setup_completion dir l
    _fzf_setup_completion dir la
    _fzf_setup_completion dir ll
    _fzf_setup_completion dir ls
    _fzf_setup_completion path e
    _fzf_setup_completion path g
    _fzf_setup_completion path git
fi


#===============================================================================
# Git
#===============================================================================

# 'git' with no parameters shows current status
git() {
    if [[ $# -gt 0 ]]; then
        command git "$@"
    else
        command git status
    fi
}

# cd to repo root
cg() {
    # Look in parent directories
    path="$(git rev-parse --show-toplevel 2>/dev/null)"

    # Look in child directories
    if [[ -z $path ]]; then
        path="$(find . -mindepth 2 -maxdepth 2 -type d -name .git 2>/dev/null)"
        if [[ $(echo "$path" | wc -l) -gt 1 ]]; then
            echo "Multiple repositories found:" >&2
            echo "$path" | sed 's/^.\//  /g; s/.git$//g' >&2
            return
        else
            path="${path%/.git}"
        fi
    fi

    # Go to the directory, if found
    if [[ -n $path ]]; then
        c "$path"
    else
        echo "No Git repository found in parent directories or immediate children" >&2
    fi
}

# 'gs' typo -> 'g s'
gs() {
    if [[ $# -eq 0 ]]; then
        g s
    else
        command gs "$@"
    fi
}


#===============================================================================
# History
#===============================================================================

# Start typing then use Up/Down to see *matching* history items
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Don't store duplicate entries in history
export HISTIGNORE="&"

# Save history immediately, so multiple terminals don't overwrite each other!
shopt -s histappend
PROMPT_COMMAND='history -a'

# Record multi-line commands as a single entry
shopt -s cmdhist

# Preserve new lines in history instead of converting to semi-colons
shopt -s lithist

# Confirm history expansions (e.g. "!1") before running them
shopt -s histverify

# If a history expansion fails, let the user re-edit the command
shopt -s histreedit


#===============================================================================
# man
#===============================================================================

man()
{
    # http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
        command man "$@"
}


#===============================================================================
# Mark directories to jump to
#===============================================================================

# Based on
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html

MARKPATH=$HOME/.marks

jump() {
    c -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1" >&2
}

mark() {
    mkdir -p $MARKPATH
    mark="${1:-$(basename "$PWD")}"

    if ! [[ $mark =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Invalid mark name"
        return 1
    fi

    ln -sn "$(pwd)" "$MARKPATH/$mark" && alias $mark="jump '$mark'"
}

unmark() {
    mark="${1:-$(basename "$PWD")}"

    if [[ -L $MARKPATH/$mark ]]; then
        rm -f "$MARKPATH/$mark" && unalias $mark
    else
        echo "No such mark: $mark" >&2
    fi
}

marks() {
    command ls -l --color=always --classify "$MARKPATH" | sed '1d;s/  / /g' | cut -d' ' -f9-
}

if [ -d "$MARKPATH" ]; then
    for mark in $(command ls "$MARKPATH"); do
        alias $mark="jump $mark"
    done
fi


#===============================================================================
# mv
#===============================================================================

# https://gist.github.com/premek/6e70446cfc913d3c929d7cdbfe896fef
mv() {
    if [ "$#" -ne 1 ]; then
        command mv -i "$@"
    elif [ ! -f "$1" ]; then
        command file "$@"
    else
        read -p "Rename to: " -ei "$1" newfilename &&
            [ -n "$newfilename" ] &&
            mv -iv "$1" "$newfilename"
    fi
}


#===============================================================================
# Pager
#===============================================================================

export PAGER=less

# If output fits on one screen exit immediately
export LESS=FRX

# Use lesspipe to convert non-text files, if available
if [ -x /usr/bin/lesspipe ]; then
    eval "$(/usr/bin/lesspipe)"
fi


#===============================================================================
# PHP
#===============================================================================

composer() {
    if dir="$(findup -x scripts/composer.sh)"; then
        "$dir/scripts/composer.sh" "$@"
    else
        command composer "$@"
    fi
}

php() {
    if dir="$(findup -x scripts/php.sh)"; then
        "$dir/scripts/php.sh" "$@"
    else
        command php "$@"
    fi
}

hackit() {
    # Has to be a function because it deletes the working directory
    if [ "$(basename "$(dirname "$(dirname "$PWD")")")" != "vendor" ]; then
        echo "Not in a Composer vendor directory" >&2
        return 1
    fi

    if [ -e .git ]; then
        echo "Already in development mode" >&2
        return 1
    fi

    ask "Delete this directory and reinstall in development mode?" Y || return

    local package="$(basename "$(dirname "$PWD")")/$(basename "$PWD")"
    local oldpwd="${OLDPWD:-}"
    local pwd="$PWD"

    # Delete the dist version
    cd ../../..
    rm -rf "$pwd"

    # Install the dev version
    composer update --prefer-source "$package"

    # Go back to that directory + restore "cd -" path
    cd "$pwd"
    OLDPWD="$oldpwd"

    # Switch to the latest development version
    # TODO: Detect when 'master' is not the main branch?
    git checkout master
}

hacked() {
    if [ "$(basename "$(dirname "$(dirname "$PWD")")")" != "vendor" ]; then
        echo "Not in a Composer vendor directory" >&2
        return 1
    fi

    if [ ! -e .git ]; then
        echo "Not in development mode" >&2
        return 1
    fi

    if [ -n "$(git status --porcelain)" ]; then
        echo "There are uncommitted changes" >&2
        return 1
    fi

    ask "Delete this directory and reinstall in production mode?" Y || return

    local package="$(basename "$(dirname "$PWD")")/$(basename "$PWD")"
    local oldpwd="${OLDPWD:-}"
    local pwd="$PWD"

    # Delete the dev version
    cd ../../..
    rm -rf "$pwd"

    # Install the dist version
    composer update --prefer-dist "$package"

    # Go back to that directory + restore "cd -" path
    cd "$pwd"
    OLDPWD="$oldpwd"
}


#===============================================================================
# PhpStorm
#===============================================================================

phpstorm() {
    if [ $# -gt 0 ]; then
        command phpstorm "$@" &>> ~/tmp/phpstorm.log &
    elif [ -d .idea ]; then
        command phpstorm "$PWD" &>> ~/tmp/phpstorm.log &
    else
        command phpstorm &>> ~/tmp/phpstorm.log &
    fi
}


#===============================================================================
# Postgres
#===============================================================================

# Use the 'postgres' database by default because it's more likely to exist than the current username
export PGDATABASE=postgres


#===============================================================================
# Prompt
#===============================================================================

# Defaults
prompt_default=
prompt_type=

# Load custom config options
if [ -f ~/.bashrc_config ]; then
    source ~/.bashrc_config
fi

# Enable dynamic $COLUMNS and $LINES variables
shopt -s checkwinsize

# Get hostname
prompthostname() {
    if [ -f ~/.hostname ]; then
        # Custom hostname
        cat ~/.hostname
    elif is-wsl; then
        # Titlecase hostname on Windows (no .localdomain)
        #hostname | sed 's/\(.\)\(.*\)/\u\1\L\2/'
        # Lowercase hostname on Windows (no .localdomain)
        hostname | tr '[:upper:]' '[:lower:]'
    else
        # FQDN hostname on Linux
        hostname -f
    #elif [ "$1" = "init" ]; then
    #    hostname -s
    #else
    #    echo '\H'
    fi
}

# Set the titlebar & prompt to "[user@host:/full/path]\n$"
case "$TERM" in
    xterm*|screen*)
        Titlebar="\u@$(prompthostname):\$PWD"
        # Set titlebar now, before SSH key is requested, for KeePass
        echo -ne "\033]2;${USER:-$USERNAME}@$(prompthostname init):$PWD\a"
        ;;
    *)
        Titlebar=""
        ;;
esac

# Git/Mercurial prompt
vcsprompt()
{
    # Walk up the tree looking for a .git directory
    # This is faster than trying each in turn and means we get the one
    # that's closer to us if they're nested
    root=$(pwd 2>/dev/null)
    while [ ! -e "$root/.git" ]; do
        if [ "$root" = "" ]; then break; fi
        root=${root%/*}
    done

    if [ -e "$root/.git" ]; then
        # Git
        relative=${PWD#$root}
        if [ "$relative" != "$PWD" ]; then
            echo -en "$root\033[36;1m$relative"
            #         ^yellow  ^aqua
        else
            echo -n $PWD
            #       ^yellow
        fi

        # Show the branch name / tag / id
        # Note: Using 'command git' to bypass 'hub' which is slightly slower and not needed here
        branch=`command git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ -n "$branch" -a "$branch" != "(no branch)" ]; then
            echo -e "\033[30;1m on \033[35;1m$branch\033[30;1m"
            #        ^grey       ^pink           ^light grey
        else
            tag=`command git describe --always 2>/dev/null`
            if [ -z "$tag" ]; then
                tag="(unknown)"
            fi
            echo -e "\033[30;1m at \033[35;1m$tag \033[0m(git)\033[30;1m"
            #        ^grey       ^pink        ^light grey  ^ grey
        fi
    else
        # No .git found
        echo $PWD
    fi
}

# Python virtualenvwrapper prompt
venvprompt()
{
    if [ -n "$VIRTUAL_ENV" ]; then
        echo -e " ENV=${VIRTUAL_ENV##*/}"
    fi
}

# Function to update the prompt with a given message (makes it easier to distinguish between different windows)
# TODO: Tidy this up, especially the variable names!
MSG()
{
    # Determine prompt colour
    if [ "${1:0:2}" = "--" ]; then
        # e.g. --live
        PromptType="${1:2}"
        shift
    else
        PromptType="$prompt_type"
    fi

    if [ "$PromptType" = "dev" ]; then
        prompt_color='30;42' # Green (black text)
    elif [ "$PromptType" = "live" ]; then
        prompt_color='41;1' # Red
    elif [ "$PromptType" = "staging" ]; then
        prompt_color='30;43' # Yellow (black text)
    elif [ "$PromptType" = "special" ]; then
        prompt_color='44;1' # Blue
    else
        prompt_color='45;1' # Pink
    fi

    # Display the provided message above the prompt and in the titlebar
    if [ -n "$*" ]; then
        PromptMessage="$*"
    elif [ -n "$prompt_default" ]; then
        PromptMessage="$prompt_default"
    elif is-root-user && ! is-docker; then
        PromptMessage="Logged in as ROOT!"
        prompt_color='41;1' # Red
    else
        PromptMessage=""
    fi

    if [ -n "$PromptMessage" ]; then
        # Lots of escaped characters here to prevent this being executed
        # until the prompt is displayed, so it can adjust when the window
        # is resized
        spaces="\$(printf '%*s\n' \"\$((\$COLUMNS-${#PromptMessage}-1))\" '')"
        MessageCode="\033[${prompt_color}m $PromptMessage$spaces\033[0m\n"
        TitlebarCode="\[\033]2;[$PromptMessage] $Titlebar\a\]"
    else
        MessageCode=
        TitlebarCode="\[\033]2;$Titlebar\a\]"
    fi

    # If changing the titlebar is not supported, remove that code
    if [ -z "$Titlebar" ]; then
        TitlebarCode=
    fi

    # Set the prompt
    PS1="${TitlebarCode}\n"                     # Titlebar (see above)
    PS1="${PS1}${MessageCode}"                  # Message (see above)
    PS1="${PS1}\[\033[30;1m\]["                 # [                         Grey
    PS1="${PS1}\[\033[31;1m\]\u"                # Username                  Red
    PS1="${PS1}\[\033[30;1m\]@"                 # @                         Grey
    PS1="${PS1}\[\033[32;1m\]$(prompthostname)" # Hostname                  Green
    PS1="${PS1}\[\033[30;1m\]:"                 # :                         Grey
    PS1="${PS1}\[\033[33;1m\]\`vcsprompt\`"     # Working directory / Git   Yellow
    PS1="${PS1}\[\033[30;1m\]\`venvprompt\`"    # Python virtual env        Grey
    PS1="${PS1}\[\033[30;1m\] at "              # at                        Grey
    PS1="${PS1}\[\033[37;0m\]\D{%T}"            # Time                      Light grey
    PS1="${PS1}\[\033[30;1m\]]"                 # ]                         Grey
    PS1="${PS1}\[\033[1;35m\]\$KeyStatus"       # SSH key status            Pink
    PS1="${PS1}\n"                              # (New line)
    PS1="${PS1}\[\033[31;1m\]\\\$"              # $                         Red
    PS1="${PS1}\[\033[0m\] "
}

# Default to prompt with no message
MSG


#===============================================================================
# Python
#===============================================================================

if [ -f /usr/local/bin/virtualenvwrapper_lazy.sh ]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    source /usr/local/bin/virtualenvwrapper_lazy.sh
fi


#===============================================================================
# Redis
#===============================================================================

redis()
{
    if [[ $# -ge 1 ]] && [[ $1 =~ ^[0-9]+$ ]]; then
        # e.g. "redis 1"
        redis-cli -n "$@"
    else
        redis-cli "$@"
    fi
}


#===============================================================================
# Ruby
#===============================================================================

# rvm
rvm_project_rvmrc=0 # RVM 1.22.1 breaks my 'cd' alias, and I don't need this

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


#===============================================================================
# SSH
#===============================================================================

# Fix running chromium via SSH
if [ -z "$XAUTHORITY" ]; then
    export XAUTHORITY=$HOME/.Xauthority
fi


#===============================================================================
# Sudo
#===============================================================================

# s=sudo
s() {
    if [[ $# == 0 ]]; then
        # Use eval to expand aliases
        eval "sudo $(history -p '!!')"
    else
        sudo "$@"
    fi
}

systemctl() {
    if [ "$1" = "list-units" ]; then
        # The 'list-units' subcommand is used by tab completion
        command systemctl "$@"
    else
        command sudo systemctl "$@"
    fi
}

# Add sbin folder to my path so they can be auto-completed
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"

# Add additional safety checks for cp, mv, rm
sudo() {
    if [ "$1" = "cp" -o "$1" = "mv" -o "$1" = "rm" ]; then
        exe="$1"
        shift
        command sudo "$exe" -i "$@"
    else
        command sudo "$@"
    fi
}


#===============================================================================
# Terminal settings
#===============================================================================

# Disable Ctrl-S = Stop output
if command -v stty &>/dev/null; then
    stty -ixon
fi

# Use 4 space tabs
if command -v tabs &>/dev/null; then
    # This outputs a blank line, but that doesn't seem preventable - if you
    # redirect to /dev/null it has no effect
    tabs -4
fi


#===============================================================================
# Tmux
#===============================================================================

# tmux attach (local)
tm() {
    local name="${1:-default}"

    if [ -z "$TMUX" ] && [[ "$TERM" != screen* ]]; then
        tmux -2 new -A -s "$name"
    else
        tmux -2 new -d -s "$name" 2>/dev/null
        tmux -2 switch -t "$name"
    fi
}


#===============================================================================
# User info
#===============================================================================

EMAIL=dave@davejamesmiller.com


#===============================================================================
# Vagrant
#===============================================================================

vagrant() {
    # WSL support
    local vagrant=vagrant

    if command -v vagrant.exe >/dev/null; then
        vagrant=vagrant.exe
    fi

    # No parameters
    if [ $# -eq 0 ]; then
        command $vagrant

        # 1 = Help message displayed (or maybe other errors?)
        # 127 = Command not found
        if [ $? -eq 1 ]; then
            echo "Custom commands:"
            echo "     exec      Run the given command on the guest machine"
            echo "     rebuild   Destroy and rebuild the box"
            echo "     tmux      Run tmux (terminal multiplexer) inside the guest machine"
            echo
            echo "Shortcuts:"
            echo "     bu        box update"
            echo "     d, down   suspend"
            echo "     h         tmux"
            echo "     gs        global-status"
            echo "     hosts     hostmanager - update /etc/hosts files"
            echo "     p         provision"
            echo "     s         status"
            echo "     u         up"
            echo "     uh        up && tmux"
            echo "     x         exec"
        fi

        return
    fi

    # Parse the first parameter for shortcuts - because I'm lazy!
    cmd="$1"
    shift

    case "$cmd" in
        d)     cmd=suspend       ;;
        down)  cmd=suspend       ;;
        exe)   cmd=exec          ;;
        gs)    cmd=global-status ;;
        h)     cmd=tmux          ;;
        hosts) cmd=hostmanager   ;;
        p)     cmd=provision     ;;
        s)     cmd=status        ;;
        st)    cmd=status        ;;
        stop)  cmd=halt          ;;
        u)     cmd=up            ;;
        x)     cmd=exec          ;;
    esac

    # Box update
    if [ "$cmd" = "bu" ]; then
        command $vagrant box update
        return
    fi

    # Execute a command on the guest
    if [ "$cmd" = "exec" ]; then
        command $vagrant ssh -c "cd /vagrant; $*"
        return
    fi

    # Destroy and rebuild
    if [ "$cmd" = "rebuild" ]; then
        command $vagrant destroy "$@" && command vagrant box update && command vagrant up
        return
    fi

    # up & tmux
    if [ "$cmd" = "uh" ]; then
        command $vagrant up || return
        cmd="tmux"
    fi

    # tmux
    if [ "$cmd" = "tmux" ]; then
        # TODO Refactor this whole section!

        # if [ -z "$TMUX" ]; then
        #     # Not running tmux - Run tmux inside Vagrant (if available)
        #     command vagrant ssh -- -t 'command -v tmux &>/dev/null && { tmux attach || tmux new -s default; } || bash -l'
        # else
        #     # We're running tmux on another platform - just connect as normal
        #     command vagrant ssh
        # fi

        # For some reason Cygwin -> tmux -> vagrant (ruby) -> ssh is *really* slow
        # And since I upgraded Vagrant, Cygwin -> vagrant -> ssh doesn't work properly
        # So bypass Vagrant and use the Cygwin ssh instead, always
        (umask 077 && command $vagrant ssh-config > /tmp/vagrant-ssh-config)

        if is-wsl; then
            # Fix this error:
            # Permissions 0755 for '/mnt/d/path/to/.vagrant/machines/default/virtualbox/private_key' are too open.
            # It is required that your private key files are NOT accessible by others.
            # This private key will be ignored.
            root="$(findup -f .vagrant/machines/default/virtualbox/private_key)"
            if [ -n "$root" ]; then
                rm -f /tmp/vagrant-ssh-key
                cp "$root/.vagrant/machines/default/virtualbox/private_key" /tmp/vagrant-ssh-key
                chmod 600 /tmp/vagrant-ssh-key
                sed -i "s#  IdentityFile .*#  IdentityFile /tmp/vagrant-ssh-key#" /tmp/vagrant-ssh-config
            fi
        fi

        if [ -z "$TMUX" ] && [[ "$TERM" != screen* ]]; then
            # Not running tmux - Run tmux inside Vagrant (if available)
            ssh -F /tmp/vagrant-ssh-config default -t 'command -v tmux &>/dev/null && tmux new -A -s default || bash -l'
        else
            # We're running tmux already
            ssh -F /tmp/vagrant-ssh-config default
        fi

        return
    fi

    # Other commands
    command $vagrant "$cmd" "$@"
}


#===============================================================================
# Windows
#===============================================================================

# Configure X server display
if [ -z "$DISPLAY" ] && is-wsl; then
    export DISPLAY=localhost:0.0
fi


#===============================================================================
# WordPress
#===============================================================================

find_wordpress_wp_content() {
    if [ -d wp-content ]; then
        echo wp-content
    elif [ -d www/wp-content ]; then
        echo www/wp-content
    elif [ -d ../wp-content ]; then
        echo ../wp-content
    elif [ -d ../../wp-content ]; then
        echo ../../wp-content
    elif [ -d ../../../wp-content ]; then
        echo ../../../wp-content
    else
        echo "Cannot find wp-content/ directory" >&2
        return 1
    fi
}

# cwc = "cd wp-content"
# This is because it's very hard to tab-complete "wp-content" because you have
# to type "wp-cont" before you get to a non-ambiguous prefix
cwc() {
    wp_root=$(find_wordpress_wp_content) || return
    c $wp_root
}

# cwp = "cd WordPress plugins"
cwp() {
    wp_root=$(find_wordpress_wp_content) || return
    if [ -d $wp_root/plugins ]; then
        c $wp_root/plugins
    else
        echo "Cannot find wp-content/plugins/ directory" >&2
        return 1
    fi
}

# cwt = "cd WordPress Theme"
cwt() {
    wp_root=$(find_wordpress_wp_content) || return
    if [ -d $wp_root/themes ]; then
        wp_theme=$(find $wp_root/themes -mindepth 1 -maxdepth 1 -type d -not -name twentyten -not -name twentyeleven)
        if [ $(echo "$wp_theme" | wc -l) -eq 1 ]; then
            # Only 1 non-default theme found - assume we want that
            c $wp_theme
        else
            # 0 or 2+ themes found - go to the main directory
            c $wp_root/themes
        fi
    else
        echo "Cannot find wp-content/themes/ directory" >&2
        return 1
    fi
}


#===============================================================================
# Yarn
#===============================================================================

yarn() {
    if [ "$1" = "update" ]; then
        # yarn run v1.19.1
        # error Command "update" not found.
        # info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
        shift
        command yarn upgrade "$@"
    else
        command yarn "$@"
    fi
}


#===============================================================================

# Change to the last visited directory, unless we're already in a different directory
if [[ $PWD = $HOME ]]; then
    if [[ -f ~/.bash_lastdirectory ]]; then
        # Throw away errors about that directory not existing (any more)
        command cd "$(cat ~/.bash_lastdirectory)" 2>/dev/null
    else
        # If this is the first login, try going to the web root instead
        cw >/dev/null
    fi
fi

# Load custom settings for this machine/account
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# Finally, show the current directory name & contents
_ls-current-directory
