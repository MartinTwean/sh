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

# Im Terminal wird durch Angabe von -v die loop Nummer der Partitionen angezeigt, beispielsweise loop28p1. 
# Nun kann ich das IMG mit gparted bearbeiten. 

# Damit gparted die Partition bearbeiten kann, muss diese schon 
# beim Starten von gparted mit angegeben werden. z.B. 

gparted /dev/loop0

# loop28 repräsentiert das IMG bzw. die Festplatte. Mit p1 wäre eine Partition innerhalb des Images gemeint.