#!/bin/bash
if [ "x$KERNEL" = "xLinux" ] ; then
	if $DEBIAN; then
    		echo "Debian :"$DEBIAN
    	fi
    	if $ARCHLINUX; then
    		echo "ArchLinux :"$ARCHLINUX
    	fi
fi