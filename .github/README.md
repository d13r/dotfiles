# Dotfiles

## Installation

### Installing on Linux

```bash
cd
wget djm.me/cfg
. cfg
```

### Installing on Windows Subsystem for Linux (WSL)

Install the [Fira Code](https://github.com/tonsky/FiraCode) font.

[Install Windows Terminal](https://www.microsoft.com/en-gb/p/windows-terminal/9n0dx20hk701#activetab=pivot:overviewtab). (Note: If you installed it *before* setting up Ubuntu, run "configure WSL shortcuts" to add the shortcuts.)

Click Start, search for `features` and select "Turn Windows features on or off". Tick "Windows Subsystem for Linux" and click OK. Reboot.

[Install Ubuntu](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?activetab=pivot:overviewtab). Run it, wait while it completes setup, set a username and password when prompted, then quit.

[Install VcXsrv](https://sourceforge.net/projects/vcxsrv/), then run XLaunch from the Start Menu. Accept the default settings except untick "Primary Selection". Save the configuration into the `shell:startup` folder so it's started automatically.

Launch Windows Terminal from the start menu, click the tab dropdown menu, then Ubuntu.

Run:

```bash
cd
wget djm.me/cfg
. cfg
```

**Tip:** To reinstall Ubuntu without re-downloading it, open a Command Prompt tab (or PowerShell) and run `wslconfig /u Ubuntu`, then re-launch Ubuntu from the Start Menu. It will take a few minutes to reinstall.
