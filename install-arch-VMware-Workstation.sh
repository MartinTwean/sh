#!/bin/bash
#set -e
clear
tput sgr0
tput setaf 1
echo ''
echo '                  -`'
echo '                 .o+`'
echo '                `ooo/'
echo '               `+oooo:'
echo '              `+oooooo:'
echo '              -+oooooo+:'
echo '            `/:-:++oooo+:'
echo '           `/++++/+++++++:'
echo '          `/++++++++++++++:'
echo '        `/+++ooooooooooooo/`'
echo '        ./ooosssso++osssssso+`'
echo '       .oossssso-````/ossssss+`'
echo '      -osssssso.      :ssssssso.'
echo '     :osssssss/        osssso+++.'
echo '    /ossssssss/        +ssssooo/-'
echo '  `/ossssso+/:-        -:/+osssso+-'
echo ' `+sso+:-`     ArchLinux   `.-/+oso:'
echo '`++:.                           `-/+/'
echo '.`                                 ` '
echo ''
tput sgr0

############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
#### START ### START ######## +++FUNKTION+++ ##### START ### START #######
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( archlinux-keyring )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_archlinux-keyring() {
tput sgr0
echo "*******************************************************************"
echo "Install archlinux-keyring on " $HOSTNAME
echo "*******************************************************************"
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Sy --noconfirm --needed archlinux-keyring
    #sudo pacman -Su
}
#func_install_archlinux-keyring
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( Backup package_list )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_backup_package_list() {
tput sgr0
echo "*******************************************************************"
echo "Backup package_list from "$HOSTNAME
echo "*******************************************************************"
   sudo pacman -Qe | awk '{print $1}' > $HOME/$(date +%d-%m-%Y_%H_%M_%S)-package-list.txt
}
func_backup_package_list
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


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
function func_install_or_not() {
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


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit pacman )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_pacman() {
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
function func_install_aur() {
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
function func_install_yay() {
tput sgr0
echo "*******************************************************************"
echo "Install mit YAY "${1}
echo "*******************************************************************"
  yay -S --noconfirm --needed ${1}
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
##### END ###### END ######## +++FUNKTION+++ ##### END ###### END ########
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########



#+++++++++++ ####### ++++++++ ############## ++++++++++++ ####### ++++++++
#+++++ START +++ START ++++++ ####+LISTE+### +++++ START +++ START +++++++
#+++++++++++ ####### ++++++++ ############## ++++++++++++ ####### ++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of AUR software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of AUR software "
echo "*******************************************************************"
list_aur=(
ncurses5-compat-libs
vmware-workstation
)

count=0

for name in "${list_aur[@]}" ; do
    count=$[count+1]
    func_install_or_not $name func_install_aur
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of YAY software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of YAY software "
echo "*******************************************************************"
list_yay=(
)

count=0

for name in "${list_yay[@]}" ; do
    count=$[count+1]
    func_install_or_not $name func_install_yay
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++ ####### ++++++++ ############## ++++++++++++ ####### ++++++++
#+++++++ END ++++ END +++++++ ####+LISTE+### +++++++ END ++++ END ++++++++
#+++++++++++ ####### ++++++++ ############## ++++++++++++ ####### ++++++++

tput sgr0

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Configure VMware Workstation systemd services
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Add vmware.service -----------------------------------------------------
cat <<EOF | sudo tee /etc/systemd/system/vmware.service
[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware start
ExecStop=/etc/init.d/vmware stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
# Add vmware.service -----------------------------------------------------

# Add vmware-usbarbitrator.service ---------------------------------------
cat <<EOF | sudo tee /etc/systemd/system/vmware-usbarbitrator.service
[Unit]
Description=VMware USB Arbitrator
Requires=vmware.service
After=vmware.service

[Service]
ExecStart=/usr/bin/vmware-usbarbitrator
ExecStop=/usr/bin/vmware-usbarbitrator --kill
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
# Add vmware-usbarbitrator.service ---------------------------------------

# Fügen Sie diesen Dienst ebenfalls hinzu, wenn Sie von einer anderen Workstation Server Console aus eine Verbindung zu Ihrer VMware Workstation-Installation herstellen möchten:
# cat <<EOF | sudo tee /etc/systemd/system/vmware-workstation-server.service
# [Unit]
# Description=VMware Workstation Server
# Requires=vmware.service
# After=vmware.service
# 
# [Service]
# ExecStart=/etc/init.d/vmware-workstation-server start
# ExecStop=/etc/init.d/vmware-workstation-server stop
# PIDFile=/var/lock/subsys/vmware-workstation-server
# RemainAfterExit=yes
# 
# [Install]
# WantedBy=multi-user.target
# EOF
# ------------------------------------------------------------------------

# Recompiling VMware kernel modules
# sudo  vmware-modconfig --console --install-all

# sudo systemctl enable vmware-networks.service vmware-usbarbitrator.service vmware-workstation-server.service
# sudo systemctl start vmware-networks.service vmware-usbarbitrator.service vmware-workstation-server.service

# Start VMware services --------------------------------------------------
sudo systemctl daemon-reload
sudo systemctl start vmware.service vmware-usbarbitrator.service
sudo systemctl enable vmware.service vmware-usbarbitrator.service


sudo modprobe -a vmw_vmci vmmon


# mks.enable3d = "TRUE"
# mks.gl.allowBlacklistedDrivers = "TRUE"

tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0
tput setaf 8
echo " All packages installed"

tput setaf 11
echo " Reboot your system"
tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0

yay --noconfirm -Scc
sudo pacman --noconfirm -Scc