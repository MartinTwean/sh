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
# Function ( Systemctl )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function systemctl_start () {
   tput sgr0
    echo "*******************************************************************"
    echo "systemctl - "${paketname}
    echo "*******************************************************************"
    sudo systemctl enable --now ${paketname}
    sudo systemctl start --now ${paketname}
    # sudo systemctl status ${paketname}
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
# Function ( CleanUP )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_cleanup() {
tput sgr0
echo "*******************************************************************"
echo "CleanUP on " $HOSTNAME
echo "*******************************************************************"
    sudo apt autoclean
    sudo apt clean
    sudo apt autoremove --assume-yes
    sudo dpkg --configure -a

    # Flatpak unbenutzte Runtimes löschen
    sudo flatpak uninstall --unused -y

    # Removes old revisions of snaps
    # CLOSE ALL SNAPS BEFORE RUNNING THIS
    LANG=C snap list --all | while read snapname ver rev trk pub notes; do if [[ $notes = *disabled* ]]; then sudo snap remove "$snapname" --revision="$rev"; fi; done

    # Starting from snap 2.34 and later, you can set the maximum number of a snap’s revisions stored by the system by setting a refresh.retain option
    sudo snap set system refresh.retain=2

    sudo du -sh /var/lib/snapd/cache/         # Get used space
    sudo rm  --force /var/lib/snapd/cache/*   # Remove cache

    sudo rm -R /home/admin/.cache/*
    sudo rm -R /tmp/*
    sudo du -sh ~/.cache/
    sudo rm -rf ~/.cache/*
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
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( settings )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_settings () {

    [ -d "usr/share/themes/Yaru/"]  ||  sudo mkdir $HOME/crypt

    # Sane settings for Gnome
    gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
    gsettings set org.gnome.desktop.interface clock-show-date true
    gsettings set org.gnome.desktop.calendar show-weekdate true
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
    gsettings set org.gnome.desktop.interface gtk-shell  'Yaru-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
    gsettings set org.gnome.desktop.interface enable-animations false

    # Sane settings for screen lock (screen off: 10 minutes, screen lock: 15 minutes)
    gsettings set org.gnome.desktop.session idle-delay 600
    gsettings set org.gnome.desktop.screensaver idle-activation-enabled 'true'
    gsettings set org.gnome.desktop.screensaver lock-enabled 'true'
    gsettings set org.gnome.desktop.screensaver lock-delay 900

    # Sane settings for Nautilus
    gsettings set org.gnome.nautilus.desktop font 'Cantarell 10'
    gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'date_modified', 'owner', 'group', 'permissions']"
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

    # Sane settings for gedit"
    gsettings set org.gnome.gedit.preferences.editor display-line-numbers true

    # compression-level
    dconf write /org/gnome/file-roller/general/compression-level "'maximum'"
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++
func_update
# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++


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
# Function ( install mit pkgs.org )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_pkgs() {
    paketname=$1
    tput sgr0
    echo "*******************************************************************"
    echo "Install mit pkgs.org "${paketname}
    echo "*******************************************************************"
    cd /tmp || exit
   
   wget http://ftp.de.debian.org/"${paketname}".deb
   sudo apt install ${paketname} --assume-yes
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of apt software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of pkgs.org software "
echo "*******************************************************************"
list_pkgs=(
   debian/pool/main/y/yaru-theme/yaru-theme-gnome-shell_22.10.3-1_all
   debian/pool/main/y/yaru-theme/yaru-theme-gtk_22.10.3-1_all
   debian/pool/main/y/yaru-theme/yaru-theme-icon_22.10.3-1_all
   debian/pool/main/y/yaru-theme/yaru-theme-unity_22.10.3-1_all
   debian/pool/main/y/yaru-theme/yaru-theme-sound_22.10.3-1_all
)

count=0

for name in "${list_pkgs[@]}" ; do
    count=$[count+1]
    func_install_pkgs $name
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0


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
list_apt=(
    gparted
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
    mc
    duf
)

count=0

for name in "${list_apt[@]}" ; do
    count=$[count+1]
    func_install_or_not $name func_install_apt
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0


# ++++++++++++++++++++++++++++ Funktionaufruf ++++++++++++++++++++++++++++
func_cleanup
# ++++++++++++++++++++++++++++ Funktionaufruf ++++++++++++++++++++++++++++


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

# pause
# sudo reboot