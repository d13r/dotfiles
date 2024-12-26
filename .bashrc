#===============================================================================
# Part of Dave James Miller's dotfiles - https://github.com/d13r/dotfiles
# To uninstall: source ~/.dotfiles/uninstall
#===============================================================================

#
# This file is executed when Bash is loaded, but ONLY in an interactive session
#
# Also see: .bash_profile
#

#===============================================================================
# Setup
#===============================================================================

#---------------------------------------
# Safety checks
#---------------------------------------

# Make sure .bash_profile is loaded first
source ~/.bash_profile

# Only load this file once
[[ -n $BASHRC_SOURCED ]] && return
BASHRC_SOURCED=true

# Only load in interactive shells
[[ -z $PS1 ]] && return

# Prevent errors if $HOME is not set (e.g. Proxmox after running Upgrade)
[[ -z $HOME ]] && return


#---------------------------------------
# Third party scripts
#---------------------------------------

# Auto-completion - seems to be loaded automatically on some servers but not on others
shopt -s extglob
[[ -f /etc/bash_completion ]] && source /etc/bash_completion

if ! declare -f _completion_loader &>/dev/null; then
    # Lazy-load not available
    for file in $HOME/.local/share/bash-completion/completions/*; do
        source "$file"
    done
fi

# fzf - fuzzy finder
if [[ -f ~/.fzf.bash ]]; then
    # Manual install
    source ~/.fzf.bash
else
    # Ubuntu package
    [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && source /usr/share/doc/fzf/examples/key-bindings.bash
    [[ -f /usr/share/doc/fzf/examples/completion.bash ]] && source /usr/share/doc/fzf/examples/completion.bash
fi

# Google Cloud Shell
[[ -f /google/devshell/bashrc.google ]] && source /google/devshell/bashrc.google

# lesspipe
[[ -x /usr/bin/lesspipe ]] && eval "$(/usr/bin/lesspipe)"

# nvm - https://github.com/nvm-sh/nvm#installing-and-updating
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# Python virtualenv
if [[ -f /usr/local/bin/virtualenvwrapper_lazy.sh ]]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    source /usr/local/bin/virtualenvwrapper_lazy.sh
fi

# Ruby rvm
if [[ -s ~/.rvm/scripts/rvm ]]; then
    rvm_project_rvmrc=0
    source ~/.rvm/scripts/rvm
fi


#===============================================================================
# Aliases
#===============================================================================

# Can't use 'maybe-sudo' because then 'sudo <something>' is expanded to
# 'sudo maybe-sudo <something>' which fails to run
if [[ $EUID -gt 0 ]] && is-executable sudo; then
    sudo='sudo'
else
    sudo=''
fi

if [[ $EUID -gt 0 ]] && is-executable sudo && ! id -nG | command grep -wq docker; then
    sudo_for_docker='sudo'
else
    sudo_for_docker=''
fi

alias a2disconf="$sudo a2disconf"
alias a2dismod="$sudo a2dismod"
alias a2dissite="$sudo a2dissite"
alias a2enconf="$sudo a2enconf"
alias a2enmod="$sudo a2enmod"
alias a2ensite="$sudo a2ensite"
alias aar="$sudo add-apt-repository"
alias acs='command apt search' # } Sudo not needed
alias acsh='command apt show'  # }
alias addgroup="$sudo addgroup"
alias adduser="$sudo adduser"
alias agac="$sudo apt autoclean"
alias agar="$sudo apt autoremove"
alias agi="$sudo apt install"
alias agp="$sudo apt purge --auto-remove"
alias agr="$sudo apt remove --auto-remove"
alias agu="$sudo apt update && $sudo apt full-upgrade --auto-remove"
alias agupdate="$sudo apt update"
alias agupgrade="$sudo apt upgrade"
alias ap='ansible-playbook'
alias apt-add-repository="$sudo apt-add-repository"
alias apt-mark="$sudo apt-mark"
alias apt="$sudo apt"
alias art='artisan'

alias b='bin'

if is-executable batcat && ! is-executable bat; then
    alias bat='batcat'
fi

alias cas='c /etc/apache2/sites-available'
alias cat="$HOME/.bin/bat-or-cat"
alias certbot="$sudo certbot"
alias chmox='chmod' # Common typo
alias cp='cp -i'
alias cy='cypress'

alias dpkg-reconfigure="$sudo dpkg-reconfigure"

alias db='dbeaver'
alias dc='docker-compose' # See function below
alias dcr='drush cr'
alias dive="$sudo_for_docker dive"
alias docker="$sudo_for_docker docker"

alias gcm='g co master'
alias goland='_idea goland'
alias grep='grep-less'
alias groupadd="$sudo groupadd"
alias groupdel="$sudo groupdel"
alias groupmod="$sudo groupmod"

alias host='_domain-command host'

alias k='kubectl'
alias ka='kubectl apply -f'
alias kcx='kubectl config use-context'
alias kd='kubectl describe'
alias ke='kubectl edit'
alias kg='kubectl get'
alias kns='kubectl config set-context --current --namespace'
alias krm='kubectl delete'

if is-mac; then
    ls_common='-GF'
else
    ls_common="-hF --color=always --hide='*.pyc' --hide='*.sublime-workspace' --hide='\$RECYCLE.BIN' --hide='desktop.ini'"
fi

alias l="ls $ls_common -l"
alias la="ls $ls_common -lA"
alias land='_idea goland'
alias ll="ls $ls_common -l"
alias ls="ls $ls_common"
alias lsa="ls $ls_common -A"

alias mux='tmuxinator'

alias ncdu='ncdu --color dark'
alias nslookup='_domain-command nslookup'

alias php5dismod="$sudo php5dismod"
alias php5enmod="$sudo php5enmod"
alias phpdismod="$sudo phpdismod"
alias phpenmod="$sudo phpenmod"
alias phpstorm='_idea phpstorm'
alias poweroff="$sudo poweroff"
alias pow="$sudo poweroff"
alias pu='phpunit'
alias puw='when-changed -r -s -1 app database tests -c "clear; bin/phpunit"'
alias pw='PASSWORD_STORE_DIR="$HOME/.password-store/MI" pvview'

alias reboot="$sudo reboot"
alias reload='exec bash -l'
alias rm='rm -i'

alias s='sudo '
alias scra="$sudo systemctl reload apache2 && $sudo systemctl status apache2"
alias service="$sudo service"
alias shutdown="$sudo poweroff"
alias sshak='ssh -o StrictHostKeyChecking=accept-new'
alias sshstop='ssh -O stop'
alias storm='_idea phpstorm'
alias sudo='sudo ' # Expand aliases
alias sw='sw ' # Expand aliases

alias tailscale="$sudo tailscale"
alias tree='tree -C'

alias u='c ..'
alias uu='c ../..'
alias uuu='c ../../..'
alias uuuu='c ../../../..'
alias uuuuu='c ../../../../..'
alias uuuuuu='c ../../../../../..'

alias ufw="$sudo ufw"
alias updb='drush updb -y'
alias updatedb="$sudo updatedb"
alias update-grub="$sudo update-grub"
alias useradd="$sudo useradd"
alias userdel="$sudo userdel"
alias usermod="$sudo usermod"

alias v='vagrant'

alias watch='watch --color '
alias whois='_domain-command whois'

alias yum="$sudo yum"


#===============================================================================
# Functions
#===============================================================================

# This is a valid function name, but not a valid alias name
-() {
    cd - "$@"
}

c() {
    # 'cd' and 'ls'
    if [[ $@ != . ]]; then
        cd "$@" >/dev/null || return
    fi
    _ls-current-directory
}

cd() {
    local dir=$PWD

    builtin cd "$@" &&
        _dirhistory-push-past "$dir" &&
        _record-last-directory
}

cg() {
    # cd to git root

    # Look in parent directories
    path=$(cd .. && git rev-parse --show-toplevel 2>/dev/null)

    # Look in child directories
    if [[ -z $path ]]; then
        path=$(find . -mindepth 2 -maxdepth 2 -type d -name .git 2>/dev/null)
        if [[ $(echo "$path" | wc -l) -gt 1 ]]; then
            echo 'Multiple repositories found:' >&2
            echo "$path" | sed 's/^.\//  /g; s/.git$//g' >&2
            return 2
        else
            path=${path%/.git}
        fi
    fi

    # Go to the directory, if found
    if [[ -z $path ]]; then
        echo 'No Git repository found in parent directories or immediate children' >&2
        return 1
    fi

    c "$path"
}

com() {
    if [[ ${1-} = 'ul' ]]; then
        shift
        composer update --lock "$@"
    else
        composer "$@"
    fi
}

cv() {
    if ! local dir=$(findup -d vendor/d13r); then
        echo 'No vendor/d13r/ directory found' >&2
        return 1
    fi

    if [[ -z $1 ]]; then
        c "$dir/vendor/d13r"
    elif [[ -d "$dir/vendor/d13r/$1" ]]; then
        c "$dir/vendor/d13r/$1"
    else
        local matches=("$dir/vendor/d13r/"*"$1"*)
        if [[ ${#matches[@]} -eq 0 || ! -d "${matches[0]}" ]]; then
            c "$dir/vendor/d13r"
            echo >&2
            c "$1" # Will fail
        elif [[ ${#matches[@]} -eq 1 ]]; then
            c "${matches[0]}"
        else
            c "$dir/vendor/d13r"
            echo >&2
            echo 'Multiple matches found:' >&2
            printf '%s\n' "${matches[@]}" >&2
        fi
    fi
}

composer() {
    if dir=$(findup -x bin/composer); then
        "$dir/bin/composer" "$@"
    else
        command composer "$@"
    fi
}

cw() {
    # cd to web root
    if [[ -d ~/repo ]]; then
        c ~/repo # cPanel
    elif [[ -d /local ]]; then
        c /local # Maths
    elif [[ -d /var/www ]]; then
        c /var/www # Ubuntu
    elif is-wsl; then
        c "$(wsl-documents-path)" # WSL
    else
        echo 'web root not found' >&2
    fi
}

cwc() {
    # cd to wp-content/
    wp_content=$(_find-wp-content) || return
    c $wp_content
}

cwp() {
    # cd to WordPress plugins
    wp_content=$(_find-wp-content) || return
    if [ -d $wp_content/plugins ]; then
        c $wp_content/plugins
    else
        echo "Cannot find wp-content/plugins/ directory" >&2
        return 1
    fi
}

cwt() {
    # cd to WordPress theme
    wp_content=$(_find-wp-content) || return
    if [ -d $wp_content/themes ]; then
        wp_theme=$(find $wp_content/themes -mindepth 1 -maxdepth 1 -type d -not -name twentyten -not -name twentyeleven)
        if [ $(echo "$wp_theme" | wc -l) -eq 1 ]; then
            # Only 1 non-default theme found - assume we want that
            c $wp_theme
        else
            # 0 or 2+ themes found - go to the main directory
            c $wp_content/themes
        fi
    else
        echo "Cannot find wp-content/themes/ directory" >&2
        return 1
    fi
}

desc() {
    if [[ $# -ne 1 ]]; then
        echo 'Usage: desc COMMAND' >&2
        return 1
    fi

    local command=$1

    if [[ $(type -t "$command") != 'file' ]]; then
        type "$command"
        return
    fi

    local file=$(command -v "$command")
    local description=$(file "$file")

    if [[ $description = *ASCII* || $description = *text* ]]; then
        BAT_STYLE='header,grid' cat "$file"
    else
        echo "$description"
    fi
}

docker-compose() {
    if dir=$(findup -x bin/docker-compose); then
        "$dir/bin/docker-compose" "$@"
    else
        command maybe-sudo-for-docker docker-compose "$@"
    fi
}

drupal() {
    if dir=$(findup -f bin/drupal); then
        "$dir/bin/drupal" "$@"
    elif dir=$(findup -f vendor/bin/drupal); then
        "$dir/vendor/bin/drupal" "$@"
    else
        command drupal "$@"
    fi
}

drush() {
    if dir=$(findup -f bin/drush); then
        "$dir/bin/drush" "$@"
    elif dir=$(findup -f vendor/bin/drush); then
        "$dir/vendor/bin/drush" "$@"
    else
        command drush "$@"
    fi
}

dump-path() {
    echo -e "${PATH//:/\\n}"
}

exitif() {
    test "$@" && exit || return 0
}

g() {
    if [[ $# -gt 0 ]]; then
        git "$@"
    elif is-executable lazygit; then
        lazygit
    else
        git status
    fi
}

gs() {
    if [[ $# -eq 0 ]]; then
        # 'gs' typo -> 'g s'
        g s
    else
        command gs "$@"
    fi
}

hacked() {
    # Switch a Composer package to dist mode
    # Has to be a function because it deletes & recreates the working directory
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

    local package=$(basename "$(dirname "$PWD")")/$(basename "$PWD")
    local oldpwd=${OLDPWD:-}
    local pwd=$PWD

    # Delete the dev version
    cd ../../..
    rm -rf "$pwd"

    # Install the dist version
    composer update --prefer-dist "$package"

    # Go back to that directory + restore "cd -" path
    cd "$pwd"
    OLDPWD=$oldpwd
}

hackit() {
    # Switch a Composer package to dev (source) mode
    # Has to be a function because it deletes & recreates the working directory
    if [ "$(basename "$(dirname "$(dirname "$PWD")")")" != "vendor" ]; then
        echo "Not in a Composer vendor directory" >&2
        return 1
    fi

    if [ -e .git ]; then
        echo "Already in development mode" >&2
        return 1
    fi

    ask "Delete this directory and reinstall in development mode?" Y || return

    local package=$(basename "$(dirname "$PWD")")/$(basename "$PWD")
    local oldpwd=${OLDPWD:-}
    local pwd=$PWD

    # Delete the dist version
    cd ../../..
    rm -rf "$pwd"

    # Install the dev version
    composer update --prefer-source "$package"

    # Go back to that directory + restore "cd -" path
    cd "$pwd"
    OLDPWD=$oldpwd

    # Switch to the latest development version
    echo
    git checkout master
}

ide() {
    if findup -f .idea/php.xml >/dev/null; then
        _idea phpstorm
    elif findup -f .idea/go.xml >/dev/null; then
        # Untested (3 Dec 2024)
        _idea goland
    elif findup -d .idea >/dev/null; then
        echo 'Cannot determine the project type'
        return 1
    else
        echo 'Cannot find .idea/ folder'
        return 1
    fi
}

man() {
    # http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
    # https://unix.stackexchange.com/questions/119/colors-in-man-pages/147#comment488743_147
    # mb=start blink, mb=start bold, me=end blink/bold
    # us=start underline, ue=end underline
    # so=start standout (file information footer), se=end standout
    LESS_TERMCAP_mb=$'\e[91;5m' \
    LESS_TERMCAP_md=$'\e[96m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[97;4m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[37;100m' \
    LESS_TERMCAP_se=$'\e[0m' \
    GROFF_NO_SGR=1 \
        command man "$@"
}

mark() {
    mkdir -p $HOME/.marks
    local mark=${1:-$(basename "$PWD")}
    local target=${2:-$PWD}

    if ! [[ $mark =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Invalid mark name"
        return 1
    fi

    ln -nsf "$target" "$HOME/.marks/$mark" &&
        alias $mark="c -P '$target'"
}

marks() {
    mkdir -p $HOME/.marks

    if is-mac; then
        CLICOLOR_FORCE=1 command ls -lF "$HOME/.marks" | sed '1d;s/  / /g' | cut -d' ' -f9-
    else
        command ls -l --color=always "$HOME/.marks" | sed '1d;s/  / /g' | cut -d' ' -f9- | {
            if is-executable column; then
                column -t
            else
                cat
            fi
        }
    fi
}

md() {
    mkdir -p "$1" && cd "$1"
}

mv() {
    # 'mv' - interactive if only one filename is given
    # https://gist.github.com/premek/6e70446cfc913d3c929d7cdbfe896fef
    if [ "$#" -ne 1 ]; then
        command mv -i "$@"
    elif [ ! -e "$1" ]; then
        command file "$@"
    else
        read -p "Rename to: " -ei "$1" newfilename &&
            [[ -n $newfilename ]] &&
            mv -iv "$1" "$newfilename"
    fi
}

nextd() {
    local dir=$PWD

    while [[ ${dirhistory_future[0]} == $dir ]]; do
        dirhistory_future=("${dirhistory_future[@]:1}")
    done

    if [[ ${#dirhistory_future[@]} -gt 0 ]]; then
        if builtin cd "${dirhistory_future[0]}"; then
            _dirhistory-push-past "$dir"
            _record-last-directory
            _ls-current-directory
        fi
    fi
}

php() {
    if dir=$(findup -x bin/php); then
        "$dir/bin/php" "$@"
    else
        command php "$@"
    fi
}

prevd() {
    local dir=$PWD

    while [[ ${dirhistory_past[0]} == $dir ]]; do
        dirhistory_past=("${dirhistory_past[@]:1}")
    done

    if [[ ${#dirhistory_past[@]} -gt 0 ]]; then
        if builtin cd "${dirhistory_past[0]}"; then
            _dirhistory-push-future "$dir"
            _record-last-directory
            _ls-current-directory
        fi
    fi
}

prompt() {
    local set_titlebar=false

    prompt_style=''

    while [[ -n $1 ]]; do
        case "$1" in
            # Stop parsing parameters
            --)             shift; break ;;

            # Set titlebar as well
            -t|--titlebar)  set_titlebar=true ;;

            # Presets
            -l|--live)      prompt_style='bg=red' ;;
            -s|--staging)   prompt_style='bg=yellow,fg=black' ;;
            -d|--dev)       prompt_style='bg=green,fg=black' ;;
            -x|--special)   prompt_style='bg=blue' ;;

            # Other colours/styles (e.g. '--bg=red' - see ~/.bash/style)
            --*)            prompt_style="$prompt_style,${1:2}" ;;

            # Finished parsing parameters
            *)              break ;;
        esac

        shift
    done

    prompt_message="$@"

    if $set_titlebar; then
        titlebar_message="$@"
    fi
}

sc() {
    case "${1:-}" in
        d|down) shift; systemctl stop "$@" ;;
        e)      shift; systemctl edit "$@" ;;
        l)      shift; systemctl log "$@" ;;
        r)      shift; systemctl reload-or-restart "$@" ;;
        rl)     shift; systemctl reload "$@" ;;
        rs)     shift; systemctl restart "$@" ;;
        s)      shift; systemctl status "$@" ;;
        u|up)   shift; systemctl start "$@" ;;
        *)             systemctl "$@"
    esac
}

scratch() {
    if [[ ! -d /scratch ]]; then
        echo '/scratch does not exist' >&2
        return 1
    fi

    if [[ ! -d "/scratch/$USER" ]]; then
        (umask 077 && mkdir -p "/scratch/$USER")
        # Also create temp directory since I have a symlink in ~/temp
        mkdir -p "/scratch/$USER/temp"
    fi

    c "/scratch/$USER"
}

setup() {
    local basename name

    # If a name is given, that's either a global script, subdirectory or repo URL
    if [[ $# -gt 0 ]]; then
        name=$1

        # Global script
        if [[ -f "$HOME/.bin/setup/$name" ]]; then
            shift
            "$HOME/.bin/setup/$name" "$@"
            return
        fi

        # Repo URL or existing subdirectory
        basename=$(basename "$name")

        if [[ ! -e $basename ]]; then
            # The 'clone' helper supports various short URL formats
            clone "$name" "$basename"
            echo
        fi

        cd "$basename"
    fi

    # If the setup script is in the normal place, call it directly
    if [[ -x bin/setup ]]; then
        bin/setup
        return
    fi

    # Otherwise use 'bin' to find it (it must be installed first)
    bin setup
}

status() {
    # Show the result of the last command
    local status=$?

    if [[ $status -eq 0 ]]; then
        style bg=lgreen,fg=black 'Success'
    else
        style bg=red,fg=lwhite "Failed with code $status"
    fi

    return $status
}

sudo() {
    # Preserve the path - https://stackoverflow.com/a/29400598/167815
    if [[ $1 = 'cp' || $1 = 'mv' || $1 = 'rm' ]]; then
        # Add additional safety checks for cp, mv, rm
        exe=$1
        shift
        sudo-preserve-env "$exe" -i "$@"
    else
        sudo-preserve-env "$@"
    fi
}

sw() {
    if [[ $# -gt 0 ]]; then
        sudo -u www-data "$@"
    else
        sudo -su www-data
    fi
}

systemctl() {
    if [[ -n ${COMP_WORDS:-} ]]; then
        # Bash completion (no sudo because it would interrupt the prompt asking for a password)
        command systemctl "$@"
    elif in-array '--user' "$@"; then
        # User mode (no sudo)
        command systemctl "$@"
    elif [[ ${1:-} = 'dr' ]]; then
        # Alias: dr=daemon-reload
        shift
        maybe-sudo systemctl daemon-reload "$@"
    elif [[ ${1:-} = 'log' ]]; then
        # Custom command: sc log [unit] [grep]
        if [[ -n ${3:-} ]]; then
            maybe-sudo journalctl --lines 100 --follow --unit "$2" --grep "$3"
        elif [[ -n ${2:-} ]]; then
            maybe-sudo journalctl --lines 100 --follow --unit "$2"
        else
            maybe-sudo journalctl --lines 100 --follow
        fi
    else
        maybe-sudo systemctl "$@"
    fi
}

terraform() {
    if dir=$(findup -f bin/terraform); then
        "$dir/bin/terraform" "$@"
    else
        command terraform "$@"
    fi
}

tf() {
    case "${1:-}" in

        a) # Apply
            shift
            terraform apply "$@"
            ;;

        an) # Apply No Refresh
            shift
            terraform apply -refresh=false "$@"
            ;;

        ar) # Apply Refresh Only
            shift
            terraform apply -refresh-only "$@"
            ;;

        i) # Init
            shift
            terraform init "$@"
            ;;

        ia) # Init and Apply
            shift
            terraform init && terraform apply "$@"
            ;;

        ian) # Init and Apply No Refresh
            shift
            terraform init && terraform apply -refresh=false "$@"
            ;;

        iar) # Init and Apply Refresh Only
            shift
            terraform init && terraform apply -refresh-only "$@"
            ;;

        mv) # State Move
            shift
            terraform state mv "$@"
            ;;

        o) # Output
            shift
            terraform output "$@"
            ;;

        p) # Plan
            shift
            terraform plan "$@"
            ;;

        v) # Validate
            shift
            terraform validate "$@"
            ;;

        *)
            terraform "$@"
            ;;

    esac
}

unmark() {
    local marks=${@:-$(basename "$PWD")}

    for mark in $marks; do
        if [[ -L $HOME/.marks/$mark ]]; then
            rm -f "$HOME/.marks/$mark" && unalias $mark
        else
            echo "No such mark: $mark" >&2
        fi
    done
}

xdebug() {
    if [[ ${1:-} = 'on' ]]; then
        export XDEBUG_SESSION=${2:-1}
    elif [[ ${1:-} = 'off' ]]; then
        unset XDEBUG_SESSION
    fi

    if [[ ${XDEBUG_SESSION:-} = 1 ]]; then
        echo "Xdebug step debugging is enabled"
    elif [[ -n ${XDEBUG_SESSION:-} ]]; then
        echo "Xdebug step debugging is enabled (trigger_value=$XDEBUG_SESSION)"
    else
        echo "Xdebug step debugging is disabled"
    fi
}

yarn() {
    # Make 'yarn' more like 'composer'
    case $1 in
        in|ins) shift; args=(install) ;;
        out) shift; args=(outdated) ;;
        re|rem) shift; args=(remove) ;;
        up|update) shift; args=(upgrade) ;;
        *) args=() ;;
    esac

    if dir=$(findup -x bin/yarn); then
        "$dir/bin/yarn" "${args[@]}" "$@"
    else
        command yarn "${args[@]}" "$@"
    fi
}


#---------------------------------------
# Helper functions
#---------------------------------------

_dirhistory-push-future() {
    if [[ ${#dirhistory_future[@]} -eq 0 || ${dirhistory_future[0]} != "$1" ]]; then
        dirhistory_future=("$1" "${dirhistory_future[@]:0:49}")
    fi
}

_dirhistory-push-past() {
    if [[ ${#dirhistory_past[@]} -eq 0 || ${dirhistory_past[0]} != "$1" ]]; then
        dirhistory_past=("$1" "${dirhistory_past[@]:0:49}")
    fi
}

_domain-command() {
    command=$1
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

_find-wp-content() {
    if dir=$(findup -d wp-content); then
        echo "$dir/wp-content"
    elif dir=$(findup -d public/wp-content); then
        echo "$dir/public/wp-content"
    else
        echo "Cannot find wp-content/ directory" >&2
        return 1
    fi
}

_idea() {
    local ide=$1
    local args=()
    local path

    shift

    if [[ $# -eq 0 ]] && path=$(findup -d .idea); then

        # Automatically launch the current project
        if is-wsl; then
            path=$(wslpath -aw "$path" | sed 's/\\\\wsl.localhost\\/\\\\wsl$\\/')
        fi

        args=($path)

    elif [[ -d ${1:-} ]] && is-wsl; then

        # Convert the path to WSL format
        path=$(wslpath -aw "$1" | sed 's/\\\\wsl.localhost\\/\\\\wsl$\\/')
        shift
        args=($path)

    fi

    # Run the IDE in the background
    command $ide "${args[@]}" "$@" &>> "$HOME/.cache/$ide.log" &
}

_ls-current-directory() {
    echo
    style lwhite,bold,underline "$PWD"

    local timeout=1
    local max_for_long=${LINES-42}
    local count

    # Allow space for the header and prompt
    (( max_for_long -= 4 ))

    local max_for_short=$(( max_for_long * 6 ))

    # Fast counting - https://stackoverflow.com/a/1427327/167815
    if ! count=$(ls -fb1 | command grep -v '^\..*' | timeout $timeout wc -l 2>/dev/null); then
        style grey "Unable to count the files in this directory within ${timeout}s"
    elif [[ $count -gt $max_for_short ]]; then
        echo "This directory contains $(printf "%'d" $count) files (excluding hidden files)"
    elif [[ $count -gt $max_for_long ]]; then
        ls
    elif ! l | command grep -v '^total '; then
        echo "This directory contains no visible files"
    fi
}

_prompt-before() {
    local status=$?

    # Save (append) the Bash history after every command, instead of waiting until exit
    history -a

    # Update $SSH_AUTH_SOCK and other variables
    if [[ -n ${TMUX-} ]]; then
        eval "$(tmux showenv -s)"
    fi

    # Update the window title (no output)
    _prompt-titlebar

    # Show the exit status for the previous command if it failed
    if [[ $status -gt 0 ]]; then
        style bg=lred,fg=black "Exited with code $status"
    fi

    # Leave a blank line between the previous command's output and this one
    echo
}

_prompt() {
    # Message
    local message=${prompt_message:-$prompt_default}
    if [[ -n $message ]]; then
        style "bg=magenta,fg=lwhite,$prompt_style" "$(printf "%-${COLUMNS}s" " $message")"
    fi

    # Information
    style -n grey '['
    style -n lred "$USER"
    style -n grey '@'
    style -n lgreen "$prompt_hostname"
    style -n grey ':'
    _prompt-pwd-git
    style -n grey ' at '
    style -n white "$(date +%H:%M:%S)"
    style -n grey ']'
}

_prompt-pwd-git() {
    local root

    # Look for .git directory (or file)
    if ! command -v git &>/dev/null || ! root=$(findup -e .git); then
        # No .git found (or git not installed) - just show the working directory
        style -n lyellow "$PWD"
        return
    fi

    # Display working directory & highlight the git root in a different colour
    local relative=${PWD#$root}
    if [[ $relative = $PWD ]]; then
        style -n lyellow "$PWD"
    else
        style -n lyellow "$root"
        style -n lcyan "$relative"
    fi

    # Branch/tag/commit
    # This must be split into two lines to get the exit code
    # https://unix.stackexchange.com/a/346880/14368
    local branch_output
    branch_output=$(command git branch --no-color 2>&1)
    if [[ $? -eq 128 && $branch_output = *"is owned by someone else"* ]]; then
        # https://github.blog/2022-04-12-git-security-vulnerability-announced/
        style -n lred ' (repo owned by another user)'
        return
    fi

    local branch=$(echo "$branch_output" | sed -nE 's/^\* (.*)$/\1/p')
    if [[ -z $branch ]]; then
        # e.g. Before any commits are made
        branch=$(command git symbolic-ref --short HEAD 2>/dev/null)
    fi
    style -n lblack ' on '
    style -n lmagenta "${branch:-(unknown)}"

    # If .git is a file, work out the actual repo root
    local git="$root/.git"
    if [[ -f $git ]]; then
        git=$(git rev-parse --git-dir)
    fi

    # Status (only the most important one, to make it easy to understand)
    if [[ -f "$git/MERGE_HEAD" ]]; then
        style -n fg=111 ' (merging)'
    elif [[ -f "$git/rebase-apply/applying" ]]; then
        style -n fg=111 ' (applying)'
    elif [[ -d "$git/rebase-merge" || -d "$git/rebase-apply/rebase-apply" ]]; then
        style -n fg=111 ' (rebasing)'
    elif [[ -f "$git/CHERRY_PICK_HEAD" ]]; then
        style -n fg=111 ' (cherry picking)'
    elif [[ -f "$git/REVERT_HEAD" ]]; then
        style -n fg=111 ' (reverting)'
    elif [[ -f "$git/BISECT_LOG" ]]; then
        style -n fg=111 ' (bisecting)'
    else
        local gstatus
        gstatus=$(timeout 1 git status --porcelain=2 --branch 2>/dev/null)
        local exitcode=$?
        local using_status_v2=true

        if [[ $exitcode -eq 129 ]]; then
            # Old version of Git - we won't be able to get ahead/behind info
            gstatus=$(timeout 1 git status --porcelain --branch 2>/dev/null)
            exitcode=$?
            using_status_v2=false
        fi

        if [[ $exitcode -eq 124 ]]; then
            style -n fg=245 ' (git timeout)'
        elif [[ -n $(echo "$gstatus" | command grep -v '^#' | head -1) ]]; then
            style -n fg=111 ' (modified)'
        elif [[ -f "$git/logs/refs/stash" ]]; then
            style -n fg=111 ' (stashed)'
        else
            local ahead behind
            read -r ahead behind <<< $(echo "$gstatus" | sed -nE 's/^# branch\.ab \+([0-9]+) \-([0-9]+)$/\1\t\2/p')

            if [[ $ahead -gt 0 ]]; then
                if [[ $behind -gt 0 ]]; then
                    style -n fg=111 ' (diverged)'
                else
                    style -n fg=111 " ($ahead ahead)"
                fi
            else
                if [[ $behind -gt 0 ]]; then
                    style -n fg=111 " ($behind behind)"
                elif $using_status_v2 && ! echo "$gstatus" | command grep -qE '^# branch.upstream '; then
                    style -n fg=245 ' (no upstream)'
                fi
            fi
        fi
    fi
}

_prompt-titlebar() {
    # This doesn't work in Windows Terminal
    #echo -ne "\001\e]2;"
    echo -ne "\e]2;"
    if [[ -n $titlebar_message ]]; then
        echo -n "[$titlebar_message] "
    fi
    echo -n "$USER@${titlebar_hostname}"
    #echo -ne "\a\002"
    echo -ne "\a"
}

_record-last-directory() {
    pwd > ~/.local/bash-last-directory
}


#===============================================================================
# Key bindings
#===============================================================================
# Also see .inputrc

# Helpers
bind -x '"\200": TEMP_LINE=$READLINE_LINE; TEMP_POINT=$READLINE_POINT'
bind -x '"\201": READLINE_LINE=$TEMP_LINE; READLINE_POINT=$TEMP_POINT; unset TEMP_POINT; unset TEMP_LINE'

# Ctrl-Alt-Left/Right
bind '"\e[1;7D": "\200\C-a\C-kprevd\C-m\201"'
bind '"\e[1;7C": "\200\C-a\C-knextd\C-m\201"'

# Ctrl-Alt-Up
bind '"\e[1;7A": "\200\C-a\C-ku\C-m\201"'

# Ctrl-Alt-Down
if declare -f __fzf_cd__ &>/dev/null; then
    # See /usr/share/doc/fzf/examples/key-bindings.bash
    bind '"\e[1;7B": "\ec"'
else
    bind '"\e[1;7B": "\C-a\C-kc \e[Z"'
fi

# Space - Expand history (!!, !$, etc.) immediately
bind 'Space: magic-space'


#===============================================================================
# Settings
#===============================================================================

dirhistory_past=()
dirhistory_future=()

export DOCKER_USER="$(id -u):$(id -g)" # https://stackoverflow.com/a/68711840/167815
export GPG_TTY=$(tty)
export HISTCONTROL='ignoreboth'
export HISTIGNORE='&'
export HISTSIZE=50000
export HISTTIMEFORMAT='[%Y-%m-%d %H:%M:%S] '
export QUOTING_STYLE='literal'

if is-executable git; then
    export NAME=$(git -C "$HOME" config --global user.name)
    export EMAIL=$(git -C "$HOME" config --global user.email)
fi

if is-wsl; then
    export BROWSER='start'
fi

shopt -s autocd
shopt -s cdspell
shopt -s checkhash
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s globstar
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s lithist
shopt -s no_empty_cmd_completion
shopt -u sourcepath

stty -ixon # Disable Ctrl-S

if is-executable tabs; then
    tabs -4
fi


#---------------------------------------
# Prompt
#---------------------------------------

# Load 'style' as a function to avoid the overhead of calling a script every time we draw the prompt
source "$HOME/.bash/style"

PROMPT_COMMAND='_prompt-before'
# Note: $() doesn't work here in Git Bash
PS1='`_prompt`\n\[\e[91m\]$\[\e[0m\] '

prompt_style=''
prompt_command=''
prompt_default=''
prompt_message=''
titlebar_message=''

if [[ -z $prompt_default ]] && is-root-user && ! is-docker; then
    prompt_style='bg=red'
    prompt_default='Logged in as ROOT!'
fi

prompt_hostname=$(get-full-hostname)
titlebar_hostname=$(get-short-hostname)


#---------------------------------------
# fzf - fuzzy finder
#---------------------------------------
# https://github.com/junegunn/fzf

# Custom filters
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

# Type "cd #<Tab>" (and other commands) to trigger fzf - because the default "cd **<Tab>" is harder to type
export FZF_COMPLETION_TRIGGER='#'

if declare -f _fzf_setup_completion &>/dev/null; then
    _fzf_setup_completion dir c
    _fzf_setup_completion dir l
    _fzf_setup_completion dir la
    _fzf_setup_completion dir ll
    _fzf_setup_completion dir ls
    _fzf_setup_completion path e
    _fzf_setup_completion path g
    _fzf_setup_completion path git
fi

# Override Alt-C / Ctrl-Alt-Down to use 'c' instead of 'cd'
# Based on /usr/share/doc/fzf/examples/key-bindings.bash
__fzf_cd__() {
  local cmd dir
  cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'c %q' "$dir"
}


#---------------------------------------
# Load marks
#---------------------------------------

if [[ -d "$HOME/.marks" ]]; then
    for target in $HOME/.marks/*; do
        mark=$(basename "$target")
        alias $mark="c -P $target"
    done
fi

#---------------------------------------
# WSLtty configuration
#---------------------------------------

# The WSLtty config file is stored outside the Git repo
if is-wsl; then
    WIN_APPDATA=$(command cd /mnt/c && cmd.exe /C 'echo %APPDATA%' | tr -d '\r')
    WIN_APPDATA_UNIX=$(wslpath "$WIN_APPDATA")

    if [[ -f $WIN_APPDATA_UNIX/wsltty/config ]] && ! cmp -s $WIN_APPDATA_UNIX/wsltty/config $HOME/.minttyrc; then
        rm -f $WIN_APPDATA_UNIX/wsltty/config
        cp $HOME/.minttyrc $WIN_APPDATA_UNIX/wsltty/config
        echo
        style bg=yellow,fg=black 'WSLtty config updated - please reload it'
    fi
fi


#---------------------------------------
# Working directory
#---------------------------------------

# Change to the last visited directory, unless we're already in a different directory
if [[ $PWD = $HOME && -f ~/.local/bash-last-directory ]]; then
    # Throw away errors about that directory not existing (any more)
    command cd "$(cat ~/.local/bash-last-directory)" 2>/dev/null
fi

_dirhistory-push-past "$PWD"


#---------------------------------------
# Custom settings / functions
#---------------------------------------

# Local settings, not committed to Git
[[ -f ~/.bashrc_local ]] && source ~/.bashrc_local


#===============================================================================
# Outputs
#===============================================================================

# Load SSH agent when connecting to gate from mobile (no SSH agent available in
# Termius free version - and the paid version is expensive for what I need!)
if [[ -z ${SSH_AUTH_SOCK-} && ${HOSTNAME-} = gate?.maths.ox.ac.uk ]]; then
    KILL_SSH_AGENT_ON_EXIT=true # Not exported
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/mi-dave.key
fi

# Automatic updates
~/.dotfiles/auto-update

# Show the current directory name & contents
# Only if running in tmux - because I normally only use a plan terminal to launch tmux
if [[ -n ${TMUX:-} ]]; then
    _ls-current-directory
fi


#===============================================================================
# Cloud Shell
#===============================================================================

#---------------------------------------
# Azure Cloud Shell
#---------------------------------------

# Azure will automatically add these if they're not in the file :-\
#ADDED_HIST_CONTROL_CHECK
#ADDED_HIST_PROMPT_COMMAND_CHECK
#source /etc/bash_completion.d/azure-cli
#PS1=${PS1//\\h/Azure}
#source /usr/bin/cloudshellhelp
