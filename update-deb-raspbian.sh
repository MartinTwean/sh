#!/bin/bash
#set -e
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# sudo chmod -x /home/pi/update-deb-raspbian.sh
# sudo crontab -e
# SHELL=/bin/bash
# PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# 30 2 * * 1 /usr/bin/bash /home/pi/update-deb-raspbian.sh
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear
tput sgr0
tput setaf 1
echo ''
echo ' _________________ '
echo '|# :           : #|'
echo '|  :           :  |'
echo '|  :           :  |'
echo '|  :           :  |'
echo '|  :___________:  |'
echo '|     _________   |'
echo '|    | __      |  |'
echo '|    ||  |     |  |'
echo '\____||__|_____|__|'
echo ''
tput sgr0

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( PAUSE )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pause() {
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( set Date and Time )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_set_time() {
 rdate -ncv ptbtime1.ptb.de
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( Backup package_list )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_backup_package_list() {
tput sgr0
echo "*******************************************************************"
echo "Backup package_list from "$HOSTNAME
echo "*******************************************************************"
   sudo apt list --installed | awk '{print $1}' > "$HOME/$(date +%d-%m-%Y_%H_%M_%S)-package-list.txt"
}
func_backup_package_list
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( upgrade )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_update () {
    sudo apt -o Acquire::ForceIPv4=true update
    sudo apt update && upgrade
    sudo apt list --upgradable
    sudo apt full-upgrade --assume-yes
    sudo apt dist-upgrade --assume-yes
    sudo apt-file update
    sudo apt autoclean
    sudo apt clean
    sudo apt autoremove --assume-yes
    sudo dpkg --configure -a
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install or not )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_or_not() {
 if dpkg -s $1 2>/dev/null >/dev/null; then
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
# Function ( install mit apt )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_apt() {
tput sgr0
echo "*******************************************************************"
echo "Install mit apt "${1}
echo "*******************************************************************"
   sudo apt install $1 --assume-yes
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++
func_install_or_not rdate func_install_apt
func_set_time
func_update
# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of apt software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of apt software "
echo "*******************************************************************"
list_apt=(
    ufw
    hwinfo
    lshw
    btop
    apt-file
    progress
    mc
    p7zip-full
    wget
    git
    duf
)

count=0
for name in "${list_apt[@]}" ; do
    count=$[count+1]
    func_install_or_not $name func_install_apt
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0


tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0
tput setaf 8
echo " All packages installed"

tput setaf 11
echo " Reboot your system with ENTER"
tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0

pause

sudo reboot