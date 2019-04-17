if $WSL; then

    # The MinTTY config file is stored outside the Git repo
    if ! cmp -s $APPDATA_UNIX/wsltty/config $HOME/.minttyrc; then
        rm -f $APPDATA_UNIX/wsltty/config
        cp $HOME/.minttyrc $APPDATA_UNIX/wsltty/config
        echo
        yellowBg black "MinTTY config updated - please reload it"
    fi

fi
