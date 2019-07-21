redis()
{
    if [[ $# -eq 1 ]] && [[ $1 =~ ^[0-9]+$ ]]; then
        # e.g. "redis 1"
        redis-cli -n "$1"
    else
        redis-cli "$@"
    fi
}
