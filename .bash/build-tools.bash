# Grunt
if command -v grunt &>/dev/null; then
    eval "$(grunt --completion=bash)"
fi

# Awe
# Use the development version of Awe in preference to the stable version
PATH="$HOME/awe/bin:$PATH"
