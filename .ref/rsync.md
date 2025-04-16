To clone the current directory to another server:

    rsync -r --links --times --delete --stats --info=progress2 ./ user@server:path

    # Or, equivalently:
    rsync -rlt --delete --stats --info=progress2 ./ user@server:path

    # Or, as root only:
    rsync -aHS --delete --stats --info=progress2 ./ user@server:path

Note: Use a trailing "/" for the source directory, but not for the target.

Explanation:

    -a = --archive = -rlptgoD
      -r = --recursive
      -l = --links
      -p = --perms
      -t = --times
      -g = --group
      -o = --owner
      -D = --devices --specials
    -H = --hard-links
    -S = --sparse

Other potentially useful options:

    -v = --verbose
    -n = --dry-run
    -z = --compress
