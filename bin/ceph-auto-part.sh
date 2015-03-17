#!/bin/sh
# 分区，格式 GPT
disk=/dev/sdb
sgdisk -og $disk
sgdisk -n 1:2048:411647       -c 1:"Linux /boot" -t 1:8300 $disk  # 200M
sgdisk -n 2:411648:4605951    -c 2:"Linux /swap" -t 2:8200 $disk  # 2G
sgdisk -n 3:4605952:46548991  -c 3:"Linux /"     -t 3:8300 $disk  # 20G
 
END=`sgdisk -E $disk`
sgdisk -n 4:46548992:$END     -c 4:"Linux /home" -t 4:8300 $disk  # ...
sgdisk -p $disk

 


# 格式化
#yes | mkfs.ext4 /dev/sda1
#yes | mkfs.ext4 /dev/sda3
#yes | mkfs.ext4 /dev/sda4
