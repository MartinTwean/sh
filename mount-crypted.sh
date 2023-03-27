sudo -i
apt install cryptsetup sshfs

lsblk

#cryptsetup luksOpen -v /dev/sda1 crypted_sda1
#mkdir /mnt/sda1
#mount /dev/mapper/crypted_sda1 /mnt/sda1


# Mount LUKS device using fstab with key (No prompt for LUKS passphrase)
# ------------------------
cryptsetup luksDump /dev/sda1
dd if=/dev/random bs=32 count=1 of=/root/lukskey
xxd /root/lukskey
#cryptsetup luksAddKey /dev/sda1
cryptsetup luksAddKey /dev/sda1 /root/lukskey

sudo nano /etc/crypttab
secret  /dev/sda1       /root/lukskey
cryptsetup luksDump /dev/sda1

sudo nano /etc/fstab
mount /dev/mapper/secret /mnt/sda1

# client
sftp://root@192.168.50.12/mnt/sda1
sshfs root@192.168.50.12:/mnt/sda1 /mnt/remote

sudo sshfs -o allow_other,default_permissions root@192.168.50.12:/mnt/sda1 /mnt/remote
sudo sshfs -o allow_other root@192.168.50.12:/mnt/sda1 /mnt/remote

