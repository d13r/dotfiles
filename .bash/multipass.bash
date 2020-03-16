if $WSL; then
    alias multipass='multipass.exe'
fi

# Slightly nicer wrapper
ubuntu() {
    case "${1:-}" in

        launch)
            # ubuntu launch - always use cloud-init
            shift
            multipass launch --cloud-init ~/cloud-config.yaml "$@"
            ;;

        shell|sh)

            if [ -n "${2:-}" ]; then
                # ubuntu shell - connect to the first VM instead of "primary"
                ip="$(multipass list --format csv | tail +2 | grep "^$2," | cut -d, -f3)"
            else
                # ubuntu shell <name>
                ip="$(multipass list --format csv | tail +2 | head -1 | cut -d, -f3)"
            fi

            if [ -n "$ip" -a "$ip" != "--" -a "$ip" != "UNKNOWN" ]; then
                # Connect via regular WSL SSH not Windows SSH, and launch tmux
                h "$ip"
            else
                echo "Cannot determine the IP to connect to. These are the running VMs:" >&2
                echo >&2
                multipass list >&2
            fi

            ;;

        *)
            multipass "$@"
            ;;

    esac
}
