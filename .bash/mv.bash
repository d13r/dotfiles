# https://gist.github.com/premek/6e70446cfc913d3c929d7cdbfe896fef

if $HAS_TERMINAL; then

    mv() {
        if [ "$#" -ne 1 ]; then
            command mv -i "$@"
        elif [ ! -f "$1" ]; then
            command file "$@"
        else
            read -p "Rename to: " -ei "$1" newfilename &&
                [ -n "$newfilename" ] &&
                mv -iv "$1" "$newfilename"
        fi
    }

fi
