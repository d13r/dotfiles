# Configure X server display
if $WINDOWS || $WSL; then
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=localhost:0.0
    fi
fi

# Clear the MSysGit MOTD (at this point it's already been shown, but this
# gets rid of it for the future)
if $MSYSGIT; then
    if [ -w /etc/motd ]; then
        > /etc/motd
    fi
fi
