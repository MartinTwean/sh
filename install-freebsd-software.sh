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
    sudo pkg update
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
 if pkg -s $1 2>/dev/null >/dev/null; then
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
# Function ( install mit pkg )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_pkg() {
tput sgr0
echo "*******************************************************************"
echo "Install mit pkg "${1}
echo "*******************************************************************"
   sudo pkg install $1 --assume-yes
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of pkg software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of pkg software "
echo "*******************************************************************"
list_apt=(
    xorg
    xfce
    kde5
    mate
    openbox
    dzen2
    tint2
    xbindkeys
    xterm
    geany
    gnome
)

count=0

for name in "${list_apt[@]}" ; do
    count=$[count+1]
    func_install_or_not $name func_install_pkg
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
