#!/bin/bash
# Installing VM-BackUP-soft.sh
# nano $HOME/Downloads/VM-BackUP-soft.sh

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
    paketname=$1
    echo "------------------------------------------------------------------------"
    echo ""
    echo "systemctl - $paketname"
    echo "------------------------------------------------------------------------"
    sudo systemctl enable --now "$paketname"
    sudo systemctl start --now "$paketname"
    # sudo systemctl status "$paketname"
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( Settings )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function func_settings() {
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

    # sudo pacman -Sy --needed --noconfirm open-vm-tools xf86-video-vmware
    # VMware - Mounting Shared Folders in a Linux Guest
    # option allow_other only allowed if 'user_allow_other' is set in /etc/fuse.conf
    # sudo nano /etc/fuse.conf
    sudo echo user_allow_other >> /etc/fuse.conf

    mkdir $HOME/Transfer
    sudo /usr/bin/vmhgfs-fuse .host:/ $HOME/Transfer -o subtype=vmhgfs-fuse,allow_other
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # sudo chmod -x /home/pi/update-deb-raspbian.sh
    # sudo crontab -e
    # SHELL=/bin/bash
    # PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    # 30 2 * * 1 /usr/bin/bash /home/pi/update-deb-raspbian.sh >> /home/pi/$(date +%Y%m%d_%H%M%S).log
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
        papirus-icon-theme
        neofetch
        nautilus-admin-git
        gnome-tweaks
        baobab
        nano
        gparted
        fakeroot
        gparted
        xf86-video-vmware
        open-vm-tools
        mc
    )

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of AUR software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_aur=(
        yay
        paru
        humanity-icon-theme
        yaru-gnome-shell-theme
        yaru-gtk-theme
        progress
        stacer
        nautilus-admin-git
        nautilus-copy-path
        gnome-shell-extension-dash-to-panel
        mkinitcpio-firmware
    )

    # aic94xx-firmware
    # wd719x-firmware

    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    # Liste of paru software
    # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    list_paru=(
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
    list_yay=(
        ulauncher
        gnome-terminal-transparency
        nautilus-admin-git
        nautilus-copy-path
        7-zip-full
        ulauncher
        prof-gnome-theme-git
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
func_install_or_not rdate aur
func_set_time
func_archlinux-keyring
func_list_of_software pacman
func_list_of_software paru
func_list_of_software aur
func_list_of_software yay
func_settings
func_cleanup
# ++++++++++ Funktionaufruf Systemupdate +++++++++++++++++++++++++++++++++


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