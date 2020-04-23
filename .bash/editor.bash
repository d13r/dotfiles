export EDITOR=vim
export GEDITOR=vim

if $MAC; then

    # Only if using a local terminal not SSH
    if [ -z "$SSH_CLIENT" ]; then
        if [ -f /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl ]; then

            # Sublime Text 2
            export EDITOR='subl -w'
            export GEDITOR=subl

        elif mvim --version &>/dev/null; then

            # MacVim
            # Note: Can't use `command -v mvim` above because the mvim script exists
            # whether or not the actual MacVim.app exists - so we have to run
            # the script to determine whether it returns an error or not
            alias gvim=mvim
            export EDITOR='mvim --cmd "let g:nonerdtree = 1" -f'
            export GEDITOR=mvim

        fi
    fi

fi

export VISUAL=$EDITOR
