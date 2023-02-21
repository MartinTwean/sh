#!/bin/bash
#set -e
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# sudo chmod -x /home/pi/update-deb-raspbian.sh
# sudo crontab -e
# SHELL=/bin/bash
# PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# 30 2 * * 1 /usr/bin/bash /home/pi/update-deb-raspbian.sh >> /home/pi/$(date +%Y%m%d_%H%M%S).log
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
echo '         `/+++ooooooooooooo/`'
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
# Function ( Backup package_list )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_backup_package_list() {
tput sgr0
echo "*******************************************************************"
echo "Backup package_list from "$HOSTNAME
echo "*******************************************************************"
   sudo pacman -Qe | awk '{print $1}' > "$HOME/$(date +%d-%m-%Y_%H_%M_%S)-package-list.txt"
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
    paketname=$1
    funcname=$2
 if pacman -Qi $paketname &> /dev/null; then
     tput sgr0
     tput setaf 1
     echo "--------------------------------------------------------------"
     tput setaf 2
     echo " The package ""$paketname"" is already installed"
   # tput sgr0
 else
     tput sgr0
     tput setaf 1
     echo "--------------------------------------------------------------"
     tput setaf 3
     echo " Installing mit ""$funcname"" packagename "$paketname
    tput sgr0
     $funcname $paketname
 fi
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit pacman )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_pacman() {
paketname=$1
tput sgr0
echo "*******************************************************************"
echo "Install mit pacman "${paketname}
echo "*******************************************************************"
   sudo pacman -S --noconfirm --needed $paketname
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install aus dem AUR )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_aur() {
    paketname=$1
tput sgr0
echo "*******************************************************************"
echo "Install aus dem AUR "${paketname}
echo "*******************************************************************"
  cd /tmp || exit
  sudo rm -rf "${paketname}"
  # Скачивание исходников.
  git clone https://aur.archlinux.org/"${paketname}".git
  # Переход в "${1}".
  cd "${paketname}" || exit
  makepkg -s --noconfirm
  sudo pacman -U --noconfirm --needed ./*.pkg.tar.*
  cd ..
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( List of software )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_list_of_software() {
    tput sgr0
    echo "*******************************************************************"
    echo " Liste of" $1 "Software"
    echo "*******************************************************************"

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of pacman software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_pacman=(
        git
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of AUR software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_aur=(
        plymouth
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   count=0
   listname=$1
   funcname=func_install_$1
   echo "Liste :$listname"
   echo "funcname :$funcname"
    if [ "$listname" == "pacman" ]; then
    	for paketname in "${list_pacman[@]}"; do	
        	count=$[count+1]
        	func_install_or_not "$paketname" "$funcname"
    		echo "paketname :" $paketname
    	done
    fi
    if [ "$listname" == "aur" ]; then
    	for paketname in "${list_aur[@]}"; do	
        	count=$[count+1]
        	func_install_or_not "$paketname" "$funcname"
    		echo "paketname :" $paketname
    	done
    fi
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    tput sgr0
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( CleanUP )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_cleanup() {
tput sgr0
echo "*******************************************************************"
echo "CleanUP on " $HOSTNAME
echo "*******************************************************************"
    sudo pacman -Rns "$(pacman -Qtdq)"

    sudo du -sh /var/lib/snapd/cache/         # Get used space
    sudo rm  --force /var/lib/snapd/cache/*   # Remove cache

    sudo rm -R /home/admin/.cache/*
    sudo rm -R /tmp/*
    sudo du -sh ~/.cache/
    sudo rm -rf ~/.cache/*

    sudo pacman -Scc --noconfirm
    sudo yaourt -Scc --noconfirm
    sudo yay -Scc --noconfirm
    sudo paru -Scc --noconfirm
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( proxzima-plymouth )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_logo() {
tput sgr0
echo "*******************************************************************"
echo "Install Logo on " $HOSTNAME
echo "*******************************************************************"
    # 1. Clone this repo or download the .zip:
    rm -Rf $HOME/proxzima-plymouth
    git clone https://github.com/PROxZIMA/proxzima-plymouth.git
    cd $HOME/proxzima-plymouth

    # 2. Copy the whole proxzima directory to plymouth themes
    sudo cp -r proxzima /usr/share/plymouth/themes

    # now set the theme (proxzima, in this case) and rebuilt the initrd
    sudo plymouth-set-default-theme -R proxzima
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
##### END ###### END ######## +++FUNKTION+++ ##### END ###### END ########
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########


# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++
func_list_of_software pacman
func_list_of_software aur
func_install_logo
func_cleanup
# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++


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

pause
sudo reboot