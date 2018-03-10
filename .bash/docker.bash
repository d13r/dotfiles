# Windows support
_docker_auto_init()
{
    if $WINDOWS && [ -z "${DOCKER_HOST:-}" ]; then
        dinit > /dev/tty
    fi
}

docker()
{
    _docker_auto_init
    if $WINDOWS; then
        eval winpty docker $(cygpathmap "$@")
    else
        command docker "$@"
    fi
}

docker-compose()
{
    _docker_auto_init
    if $WINDOWS; then
        eval winpty docker-compose $(cygpathmap "$@")
    else
        command docker-compose "$@"
    fi
}

alias docker-machine='winpty docker-machine'

# Shorthand
alias d='docker'
alias db='docker build'
alias dc='docker-compose'
alias dcr='docker-compose run'
alias dm='docker-machine'
alias dr='docker run'
alias dri='docker run -it'

# Clean up stopped containers and dangling (untagged) images
dclean()
{
    docker container prune
    docker image prune
}

# Environment
denv()
{
    cmd="$(docker-machine env "${1:-Docker}")" || return
    eval "$cmd"
    echo "Docker environment initialised"
}

# Kill most recent container
dkill()
{
    container="$(docker ps -ql)"

    if [ -n "$container" ]; then
        docker kill $container
    fi
}

# Kill all containers
dkillall()
{
    containers="$(docker ps -q)"

    if [ -n "$containers" ]; then
        docker kill $containers
    fi
}

# Init
dinit()
{
    docker-machine create --driver virtualbox "${1:-Docker}" || \
        docker-machine start "${1:-Docker}" || \
        true
    denv "${1:-Docker}"
}

# Resume
dresume()
{
    # http://stackoverflow.com/a/37886136/167815
    container="$(docker ps -qlf status=exited)"

    if [ -n "$container" ]; then
        docker start -ai "$container"
    else
        echo "No stopped images found." >&2
        return 1
    fi
}

# Shell
dsh()
{
    _docker_auto_init

    # Set up SSH agent forwarding
    if [ -n "$SSH_AUTH_SOCK" ]; then
        opt=(--volume \$SSH_AUTH_SOCK:/tmp/ssh-agent --env SSH_AUTH_SOCK=/tmp/ssh-agent)
    else
        opt=()
    fi

    # Build the command to run a shell on the specified image
    local image="${1:-ubuntu}"
    local entrypoint="${2:-/bin/bash}"
    shift $(($# > 2 ? 2 : $#))
    local cmd=(docker run "${opt[@]}" -it "$@" --entrypoint "$entrypoint" "$image")

    # If using Windows, we need to connect to the Docker VM first
    if $WINDOWS; then
        # -A = Enable agent forwarding, -t = Force TTY allocation
        dssh "$DOCKER_MACHINE_NAME" -At "${cmd[@]}"
    else
        "${cmd[@]}"
    fi
}

# SSH to docker-machine
dssh()
{
    _docker_auto_init

    # This avoids using 'docker-machine ssh' which breaks formatting in Cygwin
    machine="${1:-$DOCKER_MACHINE_NAME}"
    shift
    ip="$(docker-machine ip "$machine")" || return
    ssh -i "$HOME/.docker/machine/machines/$machine/id_rsa" "docker@$ip" "$@"
}

# Stop most recent container
dstop()
{
    container="$(docker ps -ql)"

    if [ -n "$container" ]; then
        docker stop $container
    fi
}

# Stop all containers
dstopall()
{
    containers="$(docker ps -q)"

    if [ -n "$containers" ]; then
        docker stop $containers
    fi
}
