#!/bin/bash
# --------------------------------------------------------------------
# --------------------- Copy Arch to other Disk ----------------------
# --------------------------------------------------------------------
# sudo mkdir /mnt/newarch
# sudo mount /dev/sdc5 /mnt/newarch
# sudo rsync -aAXv /* /mnt/newarch --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/var/tmp/*,/run/*,/mnt/*,/media/*,/lost+found}
# sudo umount /mnt/newarch
# --------------------------------------------------------------------

# -------------------------- arch-chroot -----------------------------
arch-chroot /mnt/sda5
# --------------------------------------------------------------------

# ------------------ Laufwerksbezeichnung anpassen -------------------
su root
nano /etc/fstab
# --------------------------------------------------------------------

# ------------------------- wenn key refresh -------------------------
# rm -R /etc/pacman.d/gnupg/
# rm -R /root/.gnupg/
# gpg --refresh-keys
pacman-key --ini
pacman-key --populate
pacman-key --refresh-keys
# --------------------------------------------------------------------

# ------------------------------- xfs --------------------------------
pacman -S xfsprogs
# --------------------------------------------------------------------

ls /etc/mkinitcpio.d/
mkinitcpio -p linux

sudo nano /etc/resolv.conf
mkinitcpio -p linux
mount -t proc proc /proc