#!/bin/bash
echo "* CPU temperature:"
vcgencmd measure_temp

echo -e "\n* CPU info:"
cat /proc/cpuinfo

echo -e "\n* Disk usage:"
df -h

echo -e "\n* Partitions info:"
cat /proc/partitions

echo -e "\n* Operating system details:"
cat /etc/os-release

echo -e "\n* Linux kernel version:"
cat /proc/version

echo -e "\n* Memory info:"
cat /proc/meminfo

echo -e "\n* Memory usage CPU vs GPU:"
vcgencmd get_mem arm && vcgencmd get_mem gpu

echo -e "\n* USB devices:"
lsusb

echo
