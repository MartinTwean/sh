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

# RAW Images img verkleinern
# https://gnulinux.ch/raw-images-verkleinern
# https://gnulinux.ch/rss.xml

# kpartx erlaubt den Schreibzugriff auf ein Image. Gnome Disks z.B. bindet IMG Dateien nur lesend ein.

sudo kpartx -av {IMGDatei}