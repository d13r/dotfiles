# Dotfiles

## Installation on Linux

```bash
cd
wget djm.me/dot
. dot
```

## Configuration

### Custom Git config

If it is a work machine, override my name and email address:

```bash
setup-identity dave.miller@maths.ox.ac.uk 'Dave Miller'
```

### Custom prompt message

Add one of these to `.bashrc_local`:

```bash
prompt --live 'Live server'
prompt --staging 'Staging server'
prompt --dev 'Development server'
prompt --special 'Something else'
prompt --bg=magenta --fg=lwhite --bold 'Custom styles' 
```

The short options are `-l` (live), `-s` (staging), `-d` (dev) and `-x` (special).

See [.bash/style](../.bash/style) for the supported custom styles.

Optionally add `--titlebar` (`-t`) to display the same message in the titlebar.

## Uninstallation

```bash
source ~/.dotfiles/uninstall
```

**Note:** This is rarely tested and may not delete everything.

## Windows Subsystem for Linux (WSL)

### Installation on WSL

Click Start, search for `features` and select "Turn Windows features on or off". Tick "Windows Subsystem for Linux" and click OK. Reboot.

[Install the Fira Code font](https://github.com/tonsky/FiraCode) - download and copy the `ttf/*.ttf` files to `C:\Windows\Fonts`.

[Install Windows Terminal from the Microsoft Store](https://www.microsoft.com/en-gb/p/windows-terminal/9n0dx20hk701#activetab=pivot:overviewtab).

[Install Ubuntu from the Microsoft Store](https://apps.microsoft.com/store/detail/ubuntu/9PDXGNCFSCZV). Run it, wait while it completes setup, set a username and password when prompted, then quit.

Put this in `c:\Users\dave\.wslconfig`:

```ini
[wsl2]
guiApplications=false
networkingMode=mirrored
```

[Install VcXsrv](https://sourceforge.net/projects/vcxsrv/), then run XLaunch from the Start Menu. Accept the default settings except untick "Primary Selection". Save the configuration into the `shell:startup` folder so it's started automatically.

Launch Windows Terminal from the start menu, click the tab dropdown menu, then Ubuntu.

Enter a username and password when prompted.

Then install dotfiles as normal.

### Reinstalling Ubuntu on WSL

To completely reinstall Ubuntu on WSL, close WSL, open PowerShell and run:

```bash
wsl --unregister Ubuntu
```

Then re-launch Ubuntu from the Start Menu - it will take a few minutes to reinstall.
