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
    sudo pacman -Su
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
# Function ( Gnome-Settings )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_gnome_settings() {
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
# Function ( install mit paru )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_paru() {
    paketname=$1
tput sgr0
echo "*******************************************************************"
echo "Install mit paru "${paketname}
echo "*******************************************************************"
   paru -S --noconfirm --needed $paketname
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit YAY )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_yay() {
    paketname=$1
tput sgr0
echo "*******************************************************************"
echo "Install mit YAY "${paketname}
echo "*******************************************************************"
  yay -S --noconfirm --needed ${paketname}
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

    #listname=list_$1
    funcname=func_install_$1

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of pacman software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    pacman=(
        wget
        git
        make
        libgtop
        networkmanager
        clutter
        papirus-icon-theme
        neofetch
        nautilus-admin-git
        gnome-tweaks
        baobab
        nano
        gparted
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of AUR software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    aur=(
        humanity-icon-theme
        yaru-gnome-shell-theme
        yaru-gtk-theme
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of paru software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    paru=(
        chrome-gnome-shell
        gnome-shell-extension-dash-to-panel
        gnome-shell-extension-caffeine
        gnome-shell-extension-sound-output-device-chooser
        gnome-shell-extension-tweaks-system-menu
        gnome-shell-extension-arch-update
        gnome-shell-extension-battery-status
        gnome-shell-extension-system-monitor
        gnome-shell-extension-tray-icons-reloaded
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of YAY software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    yay=(ulauncher gnome-terminal-transparency nautilus-admin-git nautilus-copy-path
    )


    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # eval ${func_install_or_not} "$VarName" "$VarNname" "$VarText"
    count=0
    for paketname in "${($1[@])}" ; do
        count=$[count+1]
        func_install_or_not "$paketname" "$funcname"
    done
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

    sudo pacman -Scc --noconfirm
    sudo yaourt -Scc --noconfirm
    sudo yay -Scc --noconfirm
    sudo paru -Scc --noconfirm
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
##### END ###### END ######## +++FUNKTION+++ ##### END ###### END ########
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########


# func_install_archlinux-keyring
func_list_of_software pacman

#func_gnome_settings
#func_cleanup

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
