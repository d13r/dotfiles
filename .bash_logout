if [[ -n ${SSH_AGENT_PID-} && -n ${KILL_SSH_AGENT_ON_EXIT-} ]]; then
    ssh-agent -k
fi
