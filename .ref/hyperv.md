================================================================================
 One-off setup
================================================================================

Install Hyper-V:

- Start > Turn Windows features on or off
- Enable Hyper-V (and all children)
- Click OK
- Reboot

Add a second network interface:

- Open Hyper-V Manager.
- Go to Action > Virtual Switch Manager.
- In "New virtual network switch", select "Internal" and click "Create Virtual Switch".
- Set the name to "Hyper-V Internal Network".
- Click OK.
- Go to Start > View network connections
- Right-click "vEthernet (Hyper-V Internal Network)" > Properties
- Select "Internet Protocol Version 4" and click Properties
- Select "Use the following IP address"
- Enter the IP "192.168.5.1"
- Click OK, then Close

Run:
    wsl-enable-forwarding

================================================================================
 Create a new VM
================================================================================

Configure DNS:

    example.djm.me    A      192.168.5.2
    *.example.djm.me  CNAME  example.djm.me

Create the VM using Multipass:

    mp l <name>

Or create it manually:

- Go to Action > New > Virtual Machine
    - If the "Before You Begin" screen is displayed, click Next
    - Enter a name for the VM, and click Next
    - Select Generation 2. Click Next
    - Enter the amount of memory to use (at least `3072 MB` for a netboot install). Leave "Dynamic Memory" ticked. Click Next
    - Select "Default Switch". Click Next
    - Enter a size for the virtual hard disk. Click Next
    - Select "Install an operating system from a bootable image file", then select the Ubuntu ISO file[1]. Click Next
      [1]: https://ubuntu.com/download/server
    - Click Finish
- Right-click the machine, then click Settings
    - In Add Hardware, select "Network Adapter" and click "Add". Set Virtual Switch to "Hyper-V Internal Network"
    - In Security, select "Microsoft UEFI Certificate Authority" (or untick "Enable Secure Boot")
    - In Processor, set the number of processors
    - Click OK
- Double-click the machine
- Click Start

Install Ubuntu:

- Language
    - Select "English (UK)"
- Installer update
    - If prompted, update to the new installer
- Keyboard configuration
    - Check layout and variant are set to "English (UK)"
- Choose type of install
    - Leave the default selection, "Ubuntu Server"
- Network connections
    - Select "eth1", then "Edit IPv4"
        - Select method "Manual"
        - Enter subnet "192.168.5.0/24"
        - Enter address "192.168.5.2" (make sure the last part is unique for each VM)
        - Leave the other fields blank
- Configure proxy
    - Leave it blank
- Configure Ubuntu archive mirror
    - Leave the default value
- Guided storage configuration
    - Leave the default selection, "Use An Entire Disk"
- Storage configuration
    - Change "ubuntu-lv" to use all available space (just enter "999")
    - Select "Done", then "Continue"
- Profile setup
    - Enter your name
    - Enter the server name (local part only - e.g. "kara")
    - Choose a username and password that you will use to log in
- Upgrade to Ubuntu Pro
    - Skip
- SSH Setup
    - Tick "Install OpenSSH Server"
    - Optionally select "Import SSH identity from GitHub" and enter your username to import your SSH key
- Featured Server Snaps
    - Don't select any
- Installing system
    - Wait for it to finish
- Installation complete!
    - Select "Reboot"
    - When prompted, press Enter to reboot (the virtual DVD is ejected automatically - ignore any "Failed unmounting cdrom" errors)

Take a snapshot (optional).

Close the window and the main Hyper-V window.

Connect via SSH:

    h example

Set up guest OS:

    setup linux

Add it to dotfiles (optional):

    e .ssh/config
