# Configure X server display
if $WINDOWS || $WSL; then
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=localhost:0.0
    fi
fi

# Emulate apt-get with apt-cyg
if $CYGWIN; then
    alias agi='apt-cyg install'
    alias agr='apt-cyg remove'
    alias agu='apt-cyg update'
    alias acs='apt-cyg searchall'
fi

# Clear the MSysGit MOTD (at this point it's already been shown, but this
# gets rid of it for the future)
if $MSYSGIT; then
    if [ -w /etc/motd ]; then
        > /etc/motd
    fi
fi
