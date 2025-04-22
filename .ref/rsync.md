To clone the current directory to another server:

    rsync -rlt --delete --stats --info=progress2 ./ user@server:/path/to/target

    # Or, as root only:
    rsync -aHS --delete --stats --info=progress2 ./ user@server:/path/to/target

To clone a directory from another server:

    rsync -rlt --delete --stats --info=progress2 user@server:/path/to/source/ /path/to/target

    # Or, as root only:
    rsync -aHS --delete --stats --info=progress2 user@server:/path/to/source/ /path/to/target

Notes:

- Use a trailing `/` for the source directory, but not for the target.
- Without the `/` prefix, remote paths are relative to `$HOME`, local paths are relative to `$PWD`.

Explanation of options:

- `-a` = `--archive` = `-rlptgoD`
    - `-r` = `--recursive`
    - `-l` = `--links`
    - `-p` = `--perms`
    - `-t` = `--times`
    - `-g` = `--group`
    - `-o` = `--owner`
    - `-D` = `--devices --specials`
- `-H` = `--hard-links`
- `-S` = `--sparse`

Other potentially useful options:

- `-v` = `--verbose`
- `-n` = `--dry-run`
- `-z` = `--compress`
