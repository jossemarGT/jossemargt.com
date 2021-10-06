---

date: 2021-10-04
title: 'HowTo: Restore grub2 after Windows installation'

---
<!--more-->

I am planning to publish my latest adventures with audio processing on Linux.
Stil, in the meantime I would like to share a quick guide to restore the `grub2`
boot system after you install any Windows OS with **EFI support** on the same
machine (AKA dual boot).

## Steps

Assuming you only have Windows at your disposal and no rescue Linux pen drive,
you can proceed this way:

1. On Windows, open a new terminal with **Administrative** access
2. On the terminal run `bcdedit /set {bootmgr} path \EFI\ubuntu\grubx64.efi` (change *ubuntu* for your Linux distro's name)
3. Restart your machine. If everything worked correctly, you will see the grub2 back
4. On the grub2 menu, select your Linux distribution
5. On your Linux distribution, open a new terminal
6. On the terminal run `sudo update-grub2`

Now you're good to go, but if you want to understand what happened underneath, I
invite you to continue reading.

## The nitty-gritty details

[bcdedit](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/bcdedit)
is a command-line tool for managing "Boot Configuration Data (BCD)". So, the
command you run on Windows changed the file path for the EFI boot configuration,
in this case, we are setting the grub2 configuration file instead of the Windows'
one.

Changing the EFI boot configuration will solve half of the problem since you
still need to update grub2 to recognize the other EFI-compatible OS on the
machine (Windows). You could have done this manually by editing the grub2
configuration files, but you would be asking for trouble there. Instead, you can
simply run the `update-grub2` command, which will scan the EFI partition and
update all the files accordingly.

And that's it, you are good to hack around once again!