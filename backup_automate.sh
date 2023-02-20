#!/bin/bash

#Variablen
BACKUP_PFAD="/mnt/nas/Backup"
BACKUP_ANZAHL="5"
BACKUP_NAME="Sicherung"

function create_folder (
    if [[ ! -e $BACKUP_PFAD ]]; then
        mkdir $BACKUP_PFAD
    elif [[ ! -d $BACKUP_PFAD ]]; then
        echo "$BACKUP_PFAD already exists but is not a directory" 1>&2
    fi
)

#Festplatte einbinden
mount -t cifs -o user=USERNAME,password=PASSWORD,rw,file_mode=0777,dir_mode=0777 //IP/FREIGABE /mnt/nas

#Backup erstellen
dd if=/dev/mmcblk0 of=${BACKUP_PFAD}/$hostname-${BACKUP_NAME}-$(date +%Y%m%d).img bs=1MB

#Alte Sicherung löschen
pushd ${BACKUP_PFAD}; ls -tr ${BACKUP_PFAD}/${BACKUP_NAME}* | head -n -${BACKUP_ANZAHL} | xargs rm; popd

#Festplatte auswerfen
umount /mnt/nas