# Support for wsl-ssh-pageant - https://github.com/benpye/wsl-ssh-pageant
if $WSL && [ -f "$WIN_TEMP_UNIX/wsl-ssh-pageant.sock" ]; then
    export SSH_AUTH_SOCK="$WIN_TEMP_UNIX/wsl-ssh-pageant.sock"
fi

# Workaround for losing SSH agent connection when reconnecting tmux: update a
# symlink to the socket each time we reconnect and use that as the socket in
# every session.
# Currently not working on Mac, but I don't use it
# And it stops working on MSys when you run "reload", but I don't use that either
# And it doesn't work but also isn't necessary on WSL
if ! $MAC && ! $MSYSGIT && ! $WSL; then

    # First we make sure there's a valid socket connecting us to the agent and
    # it's not already pointing to the symlink.
    link="$HOME/.ssh/ssh_auth_sock"
    if [ "$SSH_AUTH_SOCK" != "$link" -a -S "$SSH_AUTH_SOCK" ]; then
        # We also check if the agent has any keys loaded - PuTTY will still open an
        # agent connection even if we used password authentication
        if ssh-add -l >/dev/null 2>&1; then
            ln -nsf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
        fi
    fi

    # Now that's done we can use the symlink for every session
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"

fi
