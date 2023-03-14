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
# Function ( archlinux-keyring )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_archlinux-keyring() {
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
# Function ( spiegelserver )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_spiegelserver() {
tput sgr0
echo "*******************************************************************"
echo "Auswahl der Spiegelserver on " $HOSTNAME
echo "*******************************************************************"
    # Auswahl der Spiegelserver
    pacman -Sy
    pacman -S --noconfirm reflector
    reflector --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
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
# Function ( set Date and Time )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_set_time() {
 rdate -ncv ptbtime1.ptb.de
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
# Function ( install extra )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_install_extra() {
    # install paru... 
    mkdir $HOME/Downloads/_cloned-repos
    cd $HOME/Downloads/_cloned-repos
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si  
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


    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of pacman software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_pacman=(
        wget
        git
        make
        libgtop
        networkmanager
        clutter
        papirus-icon-theme
        humanity-icon-theme
        yaru-gnome-shell-theme
        yaru-gtk-theme
        neofetch
        gnome-tweaks
        baobab
        nano
        gparted
        rclone
        rclone-browser
        rsync
        grsync
        sublime-text-4
        lutris
        ufw
        gufw
        gparted
        sshfs
        obs-studio
        onlyoffice-bin
        progress
        vlc
        thunderbird
        gthumb
        glabels
        torrential
        bleachbit
        mkvtoolnix-gui
        wireshark-qt
        audacity
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of AUR software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_aur=(
        clamav
        clamtk
        clamtk-gnome
        brscan4
        bottles
        anydesk-bin
        appimagelauncher
        kodi
        mkinitcpio-firmware
        nautilus-admin-gtk4
        nautilus-copy-path
        obs-studio
        paru
        pdfarranger
        pdfsam
        unace
        unarchiver
        unarj
        unrar
        unzip
        ulauncher
        simplenote-electron-bin
        remote-desktop-manager
        ventoy-bin
        viber
        vivaldi
        usbutils
        teamviewer
        anydesk-bin
        mpv
        stacer
        duf
        fondo
        lsd
        maestral
        quickemu
        quickgui-bin
        rpi-imager
        smartsynchronize
        virt-manager
        virt-viewer
        vivaldi
        vmware-workstation
        waterfox-classic-bin
        webcatalog-bin
        xfsprogs
        xdman
        printer-support
        nfs-utils
        librewolf
        losslesscut-bin
        jexiftoolgui
        hfsprogs
        hfsutils
        hypnotix
        hardinfo
        exfatprogs
        f2fs-tools
        e2fsprogs
        dymo-cups-drivers
        rdate
        gnome-terminal-transparency
        getpocket
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of paru software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_paru=(
        veracrypt
        7-zip-full
    )
    # chrome-gnome-shell gnome-shell-extension-dash-to-panel gnome-shell-extension-caffeine gnome-shell-extension-sound-output-device-chooser gnome-shell-extension-tweaks-system-menu gnome-shell-extension-arch-update gnome-shell-extension-battery-status gnome-shell-extension-system-monitor gnome-shell-extension-tray-icons-reloaded

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of YAY software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_yay=(
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
    if [ "$listname" == "paru" ]; then
    	for paketname in "${list_paru[@]}"; do	
        	count=$[count+1]
        	func_install_or_not "$paketname" "$funcname"
    		echo "paketname :" $paketname
    	done
    fi
    if [ "$listname" == "yay" ]; then
    	for paketname in "${list_yay[@]}"; do	
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


# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++
# func_install_or_not rdate func_install_pacman
# func_install_archlinux-keyring
func_list_of_software pacman
func_list_of_software aur
func_list_of_software paru
func_list_of_software yay
func_gnome_settings
func_cleanup
func_set_time
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

# pause
# sudo reboot