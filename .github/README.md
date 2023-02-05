# Dotfiles

## Installation

### On Linux

```bash
cd
wget djm.me/dot
. dot
```

### On Windows

Click Start, search for `features` and select "Turn Windows features on or off". Tick "Windows Subsystem for Linux" and click OK. Reboot.

[Install the Fira Code font](https://github.com/tonsky/FiraCode).

[Install Windows Terminal](https://www.microsoft.com/en-gb/p/windows-terminal/9n0dx20hk701#activetab=pivot:overviewtab). (Note: If you installed it *before* setting up Ubuntu, run "configure WSL shortcuts" to add the shortcuts.)

[Install Ubuntu](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?activetab=pivot:overviewtab). Run it, wait while it completes setup, set a username and password when prompted, then quit.

Disable WSLg by putting this in `c:\Users\<Username>\.wslconfig` ([source](https://github.com/microsoft/wslg/discussions/523#discussioncomment-1505900)):

```ini
[wsl2]
guiApplications=false
```

[Install VcXsrv](https://sourceforge.net/projects/vcxsrv/), then run XLaunch from the Start Menu. Accept the default settings except untick "Primary Selection". Save the configuration into the `shell:startup` folder so it's started automatically.

Launch Windows Terminal from the start menu, click the tab dropdown menu, then Ubuntu.

Run:

```bash
cd
wget djm.me/dot
. dot
```

**Tip:** To reinstall Ubuntu without re-downloading it, open a Command Prompt tab (or PowerShell) and run `wslconfig /u Ubuntu`, then re-launch Ubuntu from the Start Menu. It will take a few minutes to reinstall.

## Reference

Run `ref` for a list of [reference topics](../.ref), and `ref <topic>` to view one.

## Uninstalling

```bash
source ~/.dotfiles/uninstall
```

**Note:** This is rarely tested and may not delete everything.
