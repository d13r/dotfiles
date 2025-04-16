# Resizing a disk or LVM volume

## Grow the disk

Grow the disk in the hypervisor, if required.
This doesn't normally require a reboot (except in Ganeti).

## Grow the partition

Find the disk name and partition number:

    $ lsblk
    NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
    sda                         8:0    0    34G  0 disk
    ├─sda1                      8:1    0     1G  0 part /boot/efi
    ├─sda2                      8:2    0     2G  0 part /boot
    └─sda3                      8:3    0  28.9G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0  28.9G  0 lvm  /

In this case the device name is `sda`, and the partition number is `3`. Extend it to fill the available space:

    $ growpart /dev/sda 3
    CHANGED: partition=3 start=6397952 old: size=60708864 end=67106816 new: size=64905183 end=71303135

## Check the PV / VG

The physical volume should now show the free space:

    # Short version
    $ pvs
    File descriptor 63 (pipe:[22050]) leaked on pvs invocation. Parent PID 967: bash
      PV         VG        Fmt  Attr PSize   PFree
      /dev/sda3  ubuntu-vg lvm2 a--  <30.95g 2.00g

    # Detailed version
    $ pvdisplay
    File descriptor 63 (pipe:[22050]) leaked on pvdisplay invocation. Parent PID 967: bash
      --- Physical volume ---
      PV Name               /dev/sda3
      VG Name               ubuntu-vg
      PV Size               <30.95 GiB / not usable 2.98 MiB
      Allocatable           yes
      PE Size               4.00 MiB
      Total PE              7922
      Free PE               512
      Allocated PE          7410
      PV UUID               eTiYJ8-DNBQ-Bpts-UXzZ-10Iy-JFRL-MS3RzY

Ignore all the "File descriptor [...] leaked" warnings - I'm not sure what causes them.

As should the volume group:

    # Short version
    $ vgs
    File descriptor 63 (pipe:[22050]) leaked on vgs invocation. Parent PID 967: bash
      VG        #PV #LV #SN Attr   VSize   VFree
      ubuntu-vg   1   1   0 wz--n- <30.95g 2.00g

    # Detailed version
    $ vgdisplay
    File descriptor 63 (pipe:[22050]) leaked on vgdisplay invocation. Parent PID 967: bash
      --- Volume group ---
      VG Name               ubuntu-vg
      System ID
      Format                lvm2
      Metadata Areas        1
      Metadata Sequence No  3
      VG Access             read/write
      VG Status             resizable
      MAX LV                0
      Cur LV                1
      Open LV               1
      Max PV                0
      Cur PV                1
      Act PV                1
      VG Size               <30.95 GiB
      PE Size               4.00 MiB
      Total PE              7922
      Alloc PE / Size       7410 / <28.95 GiB
      Free  PE / Size       512 / 2.00 GiB
      VG UUID               XBIge3-y6C1-egnO-tTYn-pWXI-wJDM-LcGqJC

## Grow the logical volume

Get the VG/LV names:

    # Short version
    $ lvs
    File descriptor 63 (pipe:[21486]) leaked on lvs invocation. Parent PID 1060: bash
      LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
      ubuntu-lv ubuntu-vg -wi-ao---- <30.95g

    # Detailed version
    $ lvdisplay
    File descriptor 63 (pipe:[22050]) leaked on lvdisplay invocation. Parent PID 967: bash
      --- Logical volume ---
      LV Path                /dev/ubuntu-vg/ubuntu-lv
      LV Name                ubuntu-lv
      VG Name                ubuntu-vg
      LV UUID                m6ArO1-a27x-GSde-NL7B-XNsX-IbCq-SOydVt
      LV Write Access        read/write
      LV Creation host, time ubuntu-server, 2023-09-17 11:29:51 +0000
      LV Status              available
      # open                 1
      LV Size                <28.95 GiB
      Current LE             7410
      Segments               1
      Allocation             inherit
      Read ahead sectors     auto
      - currently set to     256
      Block device           253:0

And extend it:

    # By a specific amount
    $ lvextend -L +1G -r ubuntu-vg/ubuntu-lv

    # Or use all of the free space
    $ lvextend -l +100%FREE -r ubuntu-vg/ubuntu-lv
    File descriptor 63 (pipe:[22050]) leaked on lvextend invocation. Parent PID 967: bash
      Size of logical volume ubuntu-vg/ubuntu-lv changed from <28.95 GiB (7410 extents) to <30.95 GiB (7922 extents).
      Logical volume ubuntu-vg/ubuntu-lv successfully resized.

The '-r' flag tells it to also resize the filesystem (ext4, etc.), so the next section can be skipped.

You can pass the full LV Path ('/dev/ubuntu-vg/ubuntu-lv') instead of the VG/LV name
('ubuntu-vg/ubuntu-lv') if you prefer - but some LVs (e.g. Proxmox LVM Thinpool) don't have one.

## Grow the filesystem

This is not necessary if '-r' was passed to 'lvextend' - but for completeness, here is how you can grow it manually:

    $ resize2fs /dev/ubuntu-vg/ubuntu-lv
    resize2fs 1.46.5 (30-Dec-2021)
    Filesystem at /dev/ubuntu-vg/ubuntu-lv is mounted on /; on-line resizing required
    old_desc_blocks = 4, new_desc_blocks = 4
    The filesystem on /dev/ubuntu-vg/ubuntu-lv is now 8112128 (4k) blocks long.

## Check it worked

    $ df -h
    Filesystem                         Size  Used Avail Use% Mounted on
    /dev/mapper/ubuntu--vg-ubuntu--lv   31G  5.0G   24G  18% /
    [...]
