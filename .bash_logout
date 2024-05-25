if [[ -n ${SSH_AGENT_PID-} ]]; then
    ssh-agent -k
fi

if is-executable gpgconf --kill gpg-agent; then
    gpgconf --kill gpg-agent
fi
