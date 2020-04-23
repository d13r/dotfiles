# g = git
alias g='git'

# 'git' with no parameters shows current status
git() {
    if [ $# -gt 0 ]; then
        command git "$@"
    else
        command git status
    fi
}

# cd to repo root
cg() {
    # Look in parent directories
    path="$(git rev-parse --show-toplevel 2>/dev/null)"

    # Look in child directories
    if [ -z "$path" ]; then
        path="$(find . -mindepth 2 -maxdepth 2 -type d -name .git 2>/dev/null)"
        if [ $(echo "$path" | wc -l) -gt 1 ]; then
            echo "Multiple repositories found:" >&2
            echo "$path" | sed 's/^.\//  /g; s/.git$//g' >&2
            return
        else
            path="${path%/.git}"
        fi
    fi

    # Go to the directory, if found
    if [ -n "$path" ]; then
        c "$path"
    else
        echo "No Git repository found in parent directories or immediate children" >&2
    fi
}

# 'gs' typo -> 'g s'
gs() {
    if [ $# -eq 0 ]; then
        g s
    else
        command gs "$@"
    fi
}
