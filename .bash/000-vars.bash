# Detect operating system
CYGWIN=false
DOCKER=false
MSYSGIT=false
MAC=false
WINDOWS=false
WSL=false

if grep -q 'WSL\|Microsoft' /proc/version; then
    # Note: WINDOWS=false in WSL because it's more Linux-like than Windows-like
    WSL=true
    APPDATA_UNIX="$(wslpath "$APPDATA")"
    WIN_TEMP="$(cmd.exe /C 'echo %TEMP%' | tr -d '\r')"
    WIN_TEMP_UNIX=$(wslpath "$WIN_TEMP")
else
    case "$(uname -a)" in
        CYGWIN*) WINDOWS=true; CYGWIN=true ;;
        MINGW*)  WINDOWS=true; MSYSGIT=true ;;
        Darwin)  MAC=true ;;
    esac
fi

if [ -f /.dockerenv ]; then
    DOCKER=true
fi

# Detect whether there's a terminal
# - $TERM=dumb for 'scp' command
# - $BASH_EXECUTION_STRING is set for forced commands like 'gitolite'
# - [ -t 0 ] (open input file descriptor) is false when Vagrant runs 'salt-call'
if [ "$TERM" != "dumb" -a -z "${BASH_EXECUTION_STRING:-}" -a -t 0 ]; then
    HAS_TERMINAL=true
else
    HAS_TERMINAL=false
fi

