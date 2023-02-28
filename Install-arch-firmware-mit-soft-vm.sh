#!/bin/bash
# Installing VM-BackUP-soft.sh
# nano $HOME/Downloads/VM-BackUP-soft.sh

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( PAUSE )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pause() {
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install or not )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_or_not() {
 if pacman -Qi $1 &> /dev/null; then
     tput sgr0
     tput setaf 1
     echo "--------------------------------------------------------------"
     tput setaf 2
     echo " The package "$1" is already installed"
   # tput sgr0
 else
     tput sgr0
     tput setaf 1
     echo "--------------------------------------------------------------"
     tput setaf 3
     echo " Installing "$2" package "$1
    tput sgr0
     $2 $1
 fi
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# sudo nano /etc/default/grub
# sudo echo GRUB_GFXMODE=1440x900 >> /etc/default/grub
cvt 1920 1080
# Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync

xrandr -display :0 --size 1440x900
xrandr -display :0 --addmode 1440x900
xrandr -display :1 --size 1440x900
# xrandr -display :0.0 --output Virtual1 --mode 1440x900 --rate 60
# xrandr -display :0 --output Virtual1 --mode 1440x900 --rate 60
# xrandr -display :1 --output Virtual1 --mode 1440x900 --rate 60
# xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
# xrandr --addmode Virtual1 "1920x1080_60.00"
# xrandr --output Virtual1 --mode "1920x1080_60.00"

sudo timedatectl set-timezone Europe/Berlin

# sudo nano /etc/systemd/timesyncd.conf
# de.pool.ntp.org
sudo echo NTP=de.pool.ntp.org >> /etc/systemd/timesyncd.conf

sudo systemctl daemon-reload
# sudo timedatectl set-ntp off
sudo timedatectl set-ntp on

timedatectl status

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( clear )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_clear() {
yay --noconfirm -Scc
sudo pacman --noconfirm -Scc
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_clear


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( archlinux-keyring )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_archlinux-keyring() {
tput sgr0
echo "*******************************************************************"
echo "Install archlinux-keyring on " $HOSTNAME
echo "*******************************************************************"
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Sy --noconfirm --needed archlinux-keyring
    #sudo pacman -Su
}
func_install_archlinux-keyring
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( Backup package_list )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_backup_package_list() {
tput sgr0
echo "*******************************************************************"
echo "Backup package_list from "$HOSTNAME
echo "*******************************************************************"
   sudo pacman -Qe | awk '{print $1}' > $HOME/$(date +%d-%m-%Y_%H_%M_%S)-package-list.txt
}
func_backup_package_list
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit pacman )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_pacman() {
tput sgr0
echo "*******************************************************************"
echo "Install mit pacman "${1}
echo "*******************************************************************"
   sudo pacman -S --noconfirm --needed $1
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install aus dem AUR )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_aur() {
tput sgr0
echo "*******************************************************************"
echo "Install aus dem AUR "${1}
echo "*******************************************************************"
  cd /tmp
  sudo rm -rf "${1}"
  # Скачивание исходников.
  git clone https://aur.archlinux.org/"${1}".git
  # Переход в "${1}".
  cd "${1}"
  makepkg -s --noconfirm
  sudo pacman -U --noconfirm --needed ./*.pkg.tar.*
  cd ..
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit YAY )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_yay() {
tput sgr0
echo "*******************************************************************"
echo "Install mit YAY "${1}
echo "*******************************************************************"
  yay -S --noconfirm --needed ${1}
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( Systemctl )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
systemctl_enable ()
{
echo "------------------------------------------------------------------------"
echo ""
echo "systemctl - ${1}"
echo "------------------------------------------------------------------------"
  sudo systemctl enable --now "${1}"
  sudo systemctl start --now "${1}"
  # sudo systemctl status "${1}"
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( uninstall )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_uninstall() {
tput sgr0
if pacman -Qi ${1} &> /dev/null; then
 tput setaf 7
  echo "-----------------------------------------------------------------"
  echo "  The package "${1}" is installed, Uninstall"
  
  sudo pacman -Rdd --noconfirm ${1}
  #tput sgr0
 else
  tput setaf 6
  echo "-----------------------------------------------------------------"
  echo " The package "${1}" is not installed"
 
fi
 echo "-----------------------------------------------------------------"
 echo
 tput sgr0
}

# eog
# pamac-aur
# archlinux-appstream-data
echo "*******************************************************************"
echo " Uninstall " ${1}
echo "*******************************************************************"

list_uninstall=(
gnome-terminal
)

count=0

for name in "${list_uninstall[@]}" ; do
	count=$[count+1]
	func_uninstall $name
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0


############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
##### END ###### END ######## +++FUNKTION+++ ##### END ###### END ########
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########





# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of pacman software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of pacman software "
echo "*******************************************************************"
list_pacman=(
fakeroot
wget
git
pv
gparted
xf86-video-vmware
open-vm-tools
mc
)

count=0

for name in "${list_pacman[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_pacman
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of AUR software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of AUR software "
echo "*******************************************************************"
list_aur=(
progress
aic94xx-firmware
wd719x-firmware
stacer
nautilus-admin-git
nautilus-copy-path
gnome-shell-extension-dash-to-panel
yay
mkinitcpio-firmware
)

count=0

for name in "${list_aur[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_aur
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0

# pamac-all
# yaru-gnome-shell-theme yaru-colors-gtk-theme-git
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of YAY software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of YAY software "
echo "*******************************************************************"
list_yay=(
7-zip-full
ulauncher
prof-gnome-theme-git
)

count=0

for name in "${list_yay[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_yay
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

sudo dconf write /org/gnome/file-roller/general/compression-level "'maximum'"

gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Yaru-dark'

func_clear


sudo systemctl daemon-reload

# sudo pacman -Sy --needed --noconfirm open-vm-tools xf86-video-vmware
# VMware - Mounting Shared Folders in a Linux Guest
# option allow_other only allowed if 'user_allow_other' is set in /etc/fuse.conf
# sudo nano /etc/fuse.conf
sudo echo user_allow_other >> /etc/fuse.conf

mkdir $HOME/Transfer
sudo /usr/bin/vmhgfs-fuse .host:/ $HOME/Transfer -o subtype=vmhgfs-fuse,allow_other


tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0
tput setaf 8
echo " All packages installed"

tput setaf 11
echo " Start with Backup"
tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0


pause

# sudo umount /dev/sdb1
sudo mkdir /mnt/LWL-D-Daten
sudo mount /dev/sdb /mnt/LWL-D-Daten

dd if=/dev/sda bs=256M | 7z a -t7z -m0=LZMA2 -mmt=on -mx=9 -mfb=273 -ms=on -ssw -aoa -si /mnt/LWL-D-Daten/$(date +%d-%m-%Y_%H_%M_%S)_sda.img.7z | progress -m $!