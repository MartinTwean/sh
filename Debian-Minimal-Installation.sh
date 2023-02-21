#!/bin/bash

# Script nach einer Debian-Minimal-Installation

#Desktop
sudo apt -y install cinnamon

# Anwendungen
sudo apt -y install firefox-esr
sudo apt -y install firefox-esr-l10n-de
sudo apt -y install chromium
sudo apt -y install vlc
sudo apt -y install libreoffice
sudo apt -y install libreoffice-l10n-de
sudo apt -y install darktable
sudo apt -y install geany
sudo apt -y install vim

# Aliases
echo "alias update='sudo apt update && sudo apt upgrade'" >> ~/.bashrc
echo "alias ll='ls -l'" >> ~/.bashrc

### usw. ###

exit 0