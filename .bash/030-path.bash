# Note: The most general ones should be at the top, and the most specific at the
# bottom (e.g. local script) so they override the general ones if needed

# MacPorts
$MAC && PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Yarn
PATH="$HOME/.yarn/bin:$PATH"

# RVM
PATH="$HOME/.rvm/bin:$PATH"

# Composer
PATH="$HOME/.config/composer/vendor/bin:$HOME/.composer/vendor/bin:$HOME/.composer/packages/vendor/bin:$PATH"

# Go
PATH="$HOME/go/bin:$PATH"

# Custom scripts
PATH="$HOME/.bin:$PATH"

# Custom OS-specific scripts
if $MAC; then
    PATH="$HOME/.bin/osx:$PATH"
elif $WINDOWS; then
    PATH="$HOME/.bin/win:$PATH"
fi

# Custom local scripts (specific to a machine so not in Git)
PATH="$HOME/local/bin:$PATH"

# Export the path so subprocesses can use it
export PATH

# Tool to debug the path
dump_path()
{
    echo -e "${PATH//:/\\n}"
}
