# Google Cloud Shell (required)
if $HAS_TERMINAL; then
    if [ -f "/google/devshell/bashrc.google" ]; then
        source "/google/devshell/bashrc.google"
    fi
fi

# Standard config files, nicely split up
for file in ~/.bash/*; do
    source "$file"
done

# Custom settings for this machine/account
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# *After* doing the rest, show the current directory contents, except in
# Git Bash home directory - there's a load of system files in there
if $HAS_TERMINAL && ! ($WINDOWS && [ "$PWD" = "$HOME" ]); then
    c .
fi

# Git Bash loads this file *and* .bash_profile so set a flag to tell
# .bash_profile not to load .bashrc again
BASHRC_DONE=true

# Prevent Serverless Framework messing with the Bash config
# https://github.com/serverless/serverless/issues/4069
# tabtab source for serverless package
# tabtab source for sls package

# fzf - https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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

export FZF_CTRL_T_COMMAND='
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
