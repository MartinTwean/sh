sudo -i
apt install cryptsetup

cryptsetup luksOpen -v /dev/sda1 crypted_sda1
mkdir /mnt/sda1
mount /dev/mapper/crypted_sda1 /mnt/sda1


# mount /dev/mapper/crypted_sda1 /up2s3

