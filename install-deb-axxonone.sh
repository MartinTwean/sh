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
# Function ( set Date and Time )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_set_time() {
 rdate -ncv ptbtime1.ptb.de
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
    sudo apt autoremove --assume-yes
    sudo apt update
    sudo apt install mono-complete -t stretch --assume-yes

    # import the GPG key to verify the authenticity of the packages
    curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | gpg --dearmor | sudo tee /usr/share/keyrings/anydesk.gpg > /dev/null

    # import the AnyDesk repository
    echo 'deb [signed-by=/usr/share/keyrings/anydesk.gpg] http://deb.anydesk.com/ all main' | sudo tee /etc/apt/sources.list.d/anydesk.list
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

    # AnyDesk Ports
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 6568/tcp
    sudo ufw allow 50001:50003/tcp
    sudo ufw allow 50001:50003/udp

    sudo echo mustertest | anydesk --set-password
    sudo anydesk --restart-service
    anydesk --get-id
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


# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++
func_install_or_not rdate func_install_apt
func_set_time
# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++


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

# Funktion Update wird ausgef.
func_update
# ---------------------------

list_apt=(
    anydesk
    ufw
    gufw
    gparted
    xrdp
    hwinfo
    hardinfo
    btop
    apt-file
    progress
    mc
    p7zip-full
    wget
    git
    gnupg
    dirmngr
    ca-certificates
    software-properties-common
    apt-transport-https
    curl
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

pause
sudo reboot