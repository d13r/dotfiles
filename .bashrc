# Configuration
auto_unlock=1
enable_sudo=0
prompt_vcs=git
umask_user=007
umask_root=022
www_dir=

if [ -f ~/.bashrc_config ]; then
    source ~/.bashrc_config
fi

# All files are read-write by me and my group but not anyone else
if [ `id -u` -eq 0 ]
then
    umask $umask_root
else
    umask $umask_user
fi

# Add my own bin directories to the path
export PATH="$HOME/local/bin:$HOME/bin:$HOME/opt/git-extras/bin:$HOME/opt/drush:$PATH"

# Use my favourite programs
export PAGER=less
export VISUAL=vim
export EDITOR=vim

# Don't do the rest of these when using SCP, only an SSH terminal
if [ "$TERM" != "dumb" ]; then

    # Use the complete version of Vim on Windows instead of the cut down version
    # that's included with Git Bash
    for myvim in \
        "/c/Program Files (x86)/Vim/vim73/vim.exe" \
        "/c/Program Files/Vim/vim73/vim.exe";
    do
        if [ -f "$myvim" ]; then
            export VISUAL="\"$myvim\""
            export EDITOR="\"$myvim\""
            alias vim="\"$myvim\""
            alias vi="\"$myvim\""
        fi
        break
    done
    unset myvim

    # Set the titlebar & prompt to "[user@host:/full/path]\n$"
    case "$TERM" in
        xterm*)
            Titlebar="\u@\h:\$PWD"
            # Set titlebar now, before SSH key is requested, for KeePass
            echo -ne "\e]2;$USER@$(hostname -s):$PWD\a"
            ;;
        *)
            Titlebar=""
            ;;
    esac

    # FIXME: $SSH_CLIENT isn't set after using "sudo -s" - is there another way to detect SSH?
    if [ -z "$SSH_CLIENT" -o "${SSH_CLIENT:0:9}" = "127.0.0.1" ]; then
        # localhost
        HostColor="37"
    else
        # SSH
        HostColor="32;1"
    fi

    # Function to update the prompt with a given message (makes it easier to distinguish between different windows)
    function MSG
    {
        # Display the provided message above the prompt and in the titlebar
        if [ -n "$*" ]; then
            MessageCode="\e[35;1m================================================================================\n $*\n================================================================================\e[0m\n"
            TitlebarCode="\[\e]2;[$*] $Titlebar\a\]"
        else
            MessageCode=
            TitlebarCode="\[\e]2;$Titlebar\a\]"
        fi

        # If changing the titlebar is not supported, remove that code
        if [ -z "$Titlebar" ]; then
            TitlebarCode=
        fi

        # VCS prompt
        # Only 1 is enabled at a time, otherwise it has to run multiple commands for every prompt
        if [ "$prompt_vcs" = "git" ] && which git >/dev/null 2>&1; then
            # Git prompt
            function myprompt
            {
                root=`git rev-parse --show-toplevel 2>/dev/null`
                if [ -n "$root" ]; then
                    # In a Git repo - highlight the root
                    relative=${PWD#$root}
                    if [ "$relative" != "$PWD" ]; then
                        branch=`git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
                        branch=${branch:-(unknown)}
                        echo -e "$root\e[36;1m$relative\e[30;1m on \e[35;1m$branch"
                        #        ^yellow      ^aqua            ^grey       ^pink
                    else
                        branch=`git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
                        branch=${branch:-(unknown)}
                        echo -e "$PWD\e[30;1m on \e[35;1m$branch"
                        #        ^yellow     ^grey       ^pink
                    fi
                else
                    # Not in Git repo
                    echo $PWD
                fi
            }
        elif [ "$prompt_vcs" = "hg" ] && which hg >/dev/null 2>&1 && hg prompt >/dev/null 2>&1; then
            # Mercurial prompt
            function myprompt
            {
                HgPrompt=`hg prompt "{root}@@@\e[0m revision \e[31;1m{rev}\e[0m{ of \e[31;1m{branch|quiet}\e[0m branch}\e[31;1m{update}{status}" 2>/dev/null`
                #                                  ^grey             ^red      ^grey        ^red               ^grey           ^red
                if [ -n "$HgPrompt" ]; then
                    # In a Mercurial repo - highlight the root
                    root=${HgPrompt/@@@*}
                    prompt=${HgPrompt/*@@@}
                    relative=${PWD#$root}
                    echo -e "$root\e[0;1m$relative$prompt"
                    #        ^yellow     ^white
                else
                    # Not in Mercurial repo
                    echo $PWD
                fi
            }
        else
            # None
            function myprompt
            {
                echo $PWD;
            }
        fi

        # Set the prompt
        PS1="${TitlebarCode}\n"                 # Titlebar (see above)
        PS1="${PS1}${MessageCode}"              # Message (see above)
        PS1="${PS1}\[\e[30;1m\]["               # [                         Grey
        PS1="${PS1}\[\e[31;1m\]\u"              # Username                  Red
        PS1="${PS1}\[\e[30;1m\]@"               # @                         Grey
        PS1="${PS1}\[\e[${HostColor}m\]\h"      # Hostname                  Green/Grey
        PS1="${PS1}\[\e[30;1m\]:"               # :                         Grey
        PS1="${PS1}\[\e[33;1m\]\`myprompt\`"    # Working directory / Git   Yellow
        PS1="${PS1}\[\e[30;1m\]]"               # ]                         Grey
        PS1="${PS1}\[\e[1;35m\]\$KeyStatus"     # SSH key status            Pink
        PS1="${PS1}\n"                          # (New line)
        PS1="${PS1}\[\e[31;1m\]\\\$"            # $                         Red
        PS1="${PS1}\[\e[0m\] "
    }

    # Default to prompt with no message
    MSG

    # For safety!
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -i'

    # Easier undoing!
    # (Not perfect because it doesn't cope with moving a file to a directory or with options but still...)
    function umv {
        mv ${2%/} ${1%/}
    }

    # Various versions of `ls`
    alias ls='ls -hF --color=always'
    alias ll='ls -hFl --color=always'
    alias la='ls -hFA --color=always'
    alias lla='ls -hFlA --color=always'

    function l {
        if [ -z "$*" ]; then
            c .
        else
            ls -hF --color=always $@
        fi
    }

    # Grep with colour and use pager
    # Note: This has to be a script not a function so it can detect a pipe
    # But the script cannot be called "grep", because that gets called by scripts
    # So we have a function "grep" calling a script "grep-less"
    function grep {
        grep-less "$@"
    }

    # If output fits on one screen, don't use less
    export LESS=FRSX

    # Unset the colours that are sometimes set (e.g. Joshua)
    export LS_COLORS=

    # md = mkdir; cd
    function md {
        mkdir "$1" && cd "$1"
    }

    # c = cd; ls
    function c {

        # If it's a file, I probably meant to type 'e' not 'c'
        if [ -n "$1" -a -f "$1" ]; then
            read -p "That is a file - open in editor instead? [Y/n] " reply
            case $reply in
                N*|n*) return ;;
                *) e "$@"; return ;;
            esac
        fi

        # cd to the first argument
        if [ "$1" = "" ]; then
            # If none then go to ~ like cd does
            cd
        elif [ "$1" != "." ]; then
            # If "." don't do anything, so that "cd -" still works
            # Don't output the path as I'm going to anyway (done by "cd -" and cdspell)
            cd "$1" >/dev/null
        fi

        # Remove that argument
        shift

        # Output the path
        echo
        echo -en "\e[4;1m"
        echo $PWD
        echo -en "\e[0m"

        # Then pass the rest to ls (just in case we have any use for that!)
        ls -h --color=always "$@"

    }

    export -f c

    # u = up
    alias u='c ..'
    alias uu='c ../..'
    alias uuu='c ../../..'
    alias uuuu='c ../../../..'
    alias uuuuu='c ../../../../..'
    alias uuuuuu='c ../../../../../..'

    # b = back
    alias b='c -'

    # various tools
    alias g='grep -ir'
    alias h='head'
    alias t='tail'

    # I keep typing this wrong:
    alias chmox='chmod'

    # chmod_g+s
    function chmod_g+s {
        if [ -z "$1" ]; then
            find . -type d -exec chmod g+s '{}' \;
        else
            find "$1" -type d -exec chmod g+s '{}' \;
        fi
    }

    # realpath
    # TODO: What's the correct way to do this without PHP?
    function realpath {
        if [ -n "$1" ]; then
            path="$1"
        else
            path="."
        fi
        echo "<?php echo realpath('$path') ?>" | php -q
        echo
    }

    # pwgen*
    alias pwgen15="pwgen -c -n -y -B 15 1"
    alias pwgen20="pwgen -c -n -y -B 20 1"

    # hg
    alias hgst="hg st"
    alias mq='hg -R $(hg root)/.hg/patches'

    # git
    if which ruby >/dev/null 2>&1; then
        alias git=hub
    fi

    # rvm
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

    # ack (Debian renames to ack-grep)
    if which ack-grep >/dev/null 2>&1; then
        alias ack="ack-grep"
    fi

    # Remember the last directory visited
    function cd {
        command cd "$@"
        pwd > ~/.bash_lastdirectory
    }

    # Go to my home directory by default
    command cd

    # Go to the stored directory now, if possible
    if [ -f ~/.bash_lastdirectory ]; then
        # Throw away errors about that directory not existing (any more)
        command cd "`cat ~/.bash_lastdirectory`" 2>/dev/null
    fi

    # Detect typos in the cd command
    shopt -s cdspell

    # Ignore case
    set completion-ignore-case on

    # Don't expand !! and friends
    # (Because I don't use it and because `echo "Hello!"` fails and `echo "Hello\!"` leaves in the \!)
    # Source: http://chris-lamb.co.uk/2007/10/09/top-10-interactive-shell-anti-patterns/
    # (Yes, I learned this command from a post telling me NOT to do it!)
    set +H

    # Start typing then use Up/Down to see *matching* history items
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'

    # Don't store duplicate entries in history
    export HISTIGNORE="&"

    # Save history immediately, so multiple terminals don't overwrite each other!
    shopt -s histappend
    PROMPT_COMMAND='history -a'

    # Disable Ctrl-S = Stop output (except it's not available in Git's Cygwin)
    if which stty >/dev/null; then
        stty -ixon
    fi

    # /home/www shortcuts
    if [ -n "$www_dir" ]; then
        alias cw="c $www_dir"
    fi

    # sudo shortcuts
    if [ $enable_sudo -eq 1 ]; then

        # sudo
        alias s='sudo'
        alias se.="se ."

        # Versions of 'sudo ls'
        alias sl='sudo ls -h --color=always'
        alias sls='sudo ls -h --color=always'
        alias sll='sudo ls -hl --color=always'
        alias sla='sudo ls -hA --color=always'
        alias slla='sudo ls -hlA --color=always'

        # apt-get
        alias agi='sudo apt-get install'
        alias agr='sudo apt-get remove'
        alias agar='sudo apt-get autoremove'
        alias agu='sudo apt-get update && sudo apt-get upgrade'
        alias acs='apt-cache search'
        alias acsh='apt-cache show'

        # Poweroff and reboot need sudo
        alias poweroff='sudo poweroff; exit'
        alias pow='sudo poweroff; exit'
        alias shutdown='sudo poweroff; exit'
        alias reboot='sudo reboot; exit'

        # Add sbin folder to my path so they can be auto-completed
        PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"

        # Additional safety checks
        function sudo {
            if [ "$1" = "cp" -o "$1" = "mv" -o "$1" = "rm" ]; then
                exe="$1"
                shift
                command sudo "$exe" -i "$@"
            else
                command sudo "$@"
            fi
        }

    fi

fi # $TERM != "dumb"

# Prevent errors when MSG is set in .bashrc_local
if [ "$TERM" = "dumb" ]; then
    function MSG {
        : Do nothing
    }
fi

# Custom settings for this machine/account
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# *After* doing the rest, show the current directory contents
if [ "$TERM" != "dumb" ]; then
    l
fi

# Git Cygwin loads this file *and* .bash_profile so set a flag to tell
# .bash_profile not to load .bashrc again
BASHRC_DONE=1
