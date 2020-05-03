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

Click Start, search for `features` and select "Turn Windows features on or off". Tick "Windows Subsystem for Linux" and click OK. Reboot.

Click Start, search for `ubuntu`, go to the Windows Store and install Ubuntu. Run it, wait while it completes setup, set a username and password when prompted, then quit.

[Install WSLtty](https://github.com/mintty/wsltty). (Note: If you installed it *before* setting up Ubuntu, run "configure WSL shortcuts" to add the shortcuts.)

[Install VcXsrv](https://sourceforge.net/projects/vcxsrv/), then run XLaunch from the Start Menu. Accept the default settings except untick "Primary Selection". Save the configuration into the `shell:startup` folder so it's started automatically.

Launch "Ubuntu Terminal" from the start menu.

Run:

```bash
cd
wget djm.me/cfg
. cfg
```

**Tip:** To reinstall Ubuntu without re-downloading it, launch Command Prompt and run `wslconfig /u ubuntu`, then re-launch Ubuntu from the Start Menu. It will take a few minutes to reinstall.
