#!/bin/bash
#set -e
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

    echo 'deb http://download.axxonsoft.com/debian-repository stable main' | sudo tee -a /etc/apt/sources.list.d/axxonsoft.list
    echo 'deb http://download.axxonsoft.com/debian-repository stretch backports/main' | sudo tee -a /etc/apt/sources.list.d/axxonsoft.list
    wget --quiet -O - "http://download.axxonsoft.com/debian-repository/info@axxonsoft.com.gpg.key" | sudo apt-key --keyring /etc/apt/trusted.gpg.d/axxonsoft.gpg add - && sudo apt-get update
    
    # If you use Ubuntu 20.04 or Debian 11, then install the mono-complete from the stretch repository:
    sudo apt purge "mono-*" "libmono-*"
    sudo apt autoremove
    sudo apt update
    sudo apt install mono-complete -t stretch
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( settings )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_settings () {
    # Enable to start after reboot and run the remote desktop sharing server xrdp:
    sudo systemctl enable --now xrdp
    
    # Open a firewall port 3389 for an incoming traffic:
    sudo ufw allow from any to any port 3389 proto tcp
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


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of apt software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of apt software "
echo "*******************************************************************"

func_update

list_apt=(
anydesk
ufw
gufw
gparted
xrdp
hwinfo
hardinfo
rdate
btop
apt-file
progress
mc
p7zip-full
wget
git
gnupg
axxon-one
axxon-one-client
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
