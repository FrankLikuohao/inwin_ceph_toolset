#!/bin/bash -vx
sudo wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
sudo echo deb http://ceph.com/debian-firefly/ $(lsb_release -sc) main \ | sudo tee /etc/apt/sources.list.d/ceph.list

#deploy server 
sudo apt-get update -y && sudo apt-get install ceph-deploy -y

#$vi /etc/hosts
#hosts file content
#172.20.150.1 deploy
#172.20.150.10 storage0
#172.20.150.11 storage1ihost
#172.20.150.12 storage2

#ssh server
#vi .ssh/config
#Host storage0
#Hostname storage0
#User inwin

#sudo user
#$echo "inwin ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/inwin
#$sudo chmod 0440 /etc/sudoers.d/inwin

#root root
#$vim /etc/ssh/sshd_config
#sshd_config_content
#PermitRootLogin without-password //將這行注釋
#PermitRootLogin yes  //增加這行

#start ssh server copy key
#$service ssh restart
#$ssh-keygen -t ecdsa
#$ssh-copy-id storage0
#ssh storage0 #test


#ceph main
#create cluster 
#ceph-deploy new storage0 	
ceph-deploy new vmon1
#ceph-deploy install  storage0 storage1 storageN
ceph-deploy install vmon1

#vi ceph.conf
#monitor
ceph-deploy mon create-initial vmon1

#osd
ceph-deploy osd create storage1:/dev/sdb storage2:/dev/sdb
#with SSD jouranl
#ceph-deploy osd prepare：ceph-deploy osd prepare $hostname:data:journal $hostname2:data:journal
#ceph-deploy osd prepare storage0:sdb1:/dev/sdd1 storage0:sdc1:/dev/sdd2 storage1:sdb1:/dev/sdd1 storage1:sdc1:/dev/sdd2 storage2:sdb1:/dev/sdd1 storage2:sdc1:/dev/sdd2
#ceph-deploy osd create vmon1:/dev/sdc:/dev/sdb1 vmon1:/dev/sdd:/dev/sdb2 vmon1:/dev/sde:/dev/sdb3

#prepare and activate
#ceph-deploy osd prepare vmon1:sdc:/dev/sdb1
#ceph-deploy osd activate vmon1:/var/lib/ceph/osd/ceph-1 (vmon1:/var/lib/ceph/osd/ceph-0 vmon1:/var/lib/ceph/osd/ceph-2)
#mkfs.xfs -f /dev/sdX ??

#keyring
#ceph-deploy admin storage1 storgae2
#remote host 
#sudo chmod +r /etc/ceph/ceph.client.admin.keyring

#ceph health
#ceph-deploy disk list  vmon1

#sudo sgdisk -Z /dev/sdb;sudo sgdisk -p /dev/sdb;sudo sgdisk -Z /dev/sdc;sudo sgdisk -p /dev/sdc;sudo sgdisk -Z /dev/sdd;sudo sgdisk -p /dev/sdd;sudo sgdisk -Z /dev/sde;sudo sgdisk -p /dev/sde




