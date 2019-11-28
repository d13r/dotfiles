# Dotfiles

These dotfiles are mine and you should not install them yourself - but feel free to copy any bits you find useful.

If you want to use them all, I suggest forking the [Alberon dotfiles](https://github.com/alberon/dotfiles) instead - see the instructions in that repo.

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

Click Start, search for `ubuntu`, go to the Windows Store and install Ubuntu. Run it, wait while it completes setup, set a username and password when prompted, then run:

```bash
cd
wget djm.me/cfg
. cfg
```

[Install WSLtty](https://github.com/mintty/wsltty). (Note: If you installed it *before* setting up Ubuntu, run "configure WSL shortcuts" to add the shortcuts.)

[Install VcXsrv](https://sourceforge.net/projects/vcxsrv/), then run XLaunch from the Start Menu. Accept the default settings except untick "Primary Selection". Save the configuration into the `shell:startup` folder so it's started automatically.

Run "Ubuntu Terminal" from the start menu. Optionally install updates and some additional packages:

```bash
agu
agar
agi dos2unix php-cli tree unzip whois zip

se /etc/wsl.conf

# Add:
[automount]
options = "umask=0022"
```

(Note: Adding `fmask=0111` to remove the `x` bit prevents WSL running Windows `.exe` commands - so don't do that!)

**Tip:** To reinstall Ubuntu without re-downloading it, launch Command Prompt and run `wslconfig /u ubuntu`, then re-launch Ubuntu from the Start Menu. It will take a few minutes to reinstall.
