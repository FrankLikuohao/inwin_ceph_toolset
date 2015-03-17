#!/bin/bash 
################################################################
#This is a script to quickly partition the ssd disk  for ceph  #
#deployment                               Frank Li 2015/03/17  #
################################################################           

if (( $# < 3 )); then
    echo "Usage: $0 devie_name  size(GiB) total_partitions (-y)"
    echo "ex: $0 /dev/sdb 1 3 "
    echo "Frank Li 2015/03/17"
    exit 1
fi

disk=$1
size_gb=$2
total_partition=$3
yes=$4

#check -y to go throught  the script or check parameter again 
if [ -z $yes  ]; then 
	yes=0
fi

if [ $yes != '-y' ]; then
	echo "Run: disk= [$disk]  size=[$size_gb]GB total_partitions=[$total_partition]"
	echo "Is it right? input(y/n)>"
		read ANSWER 
		#echo "$ANSWER"
	if (( $ANSWER != "y" )); then
		echo "Try input right parameters again!"
		exit 1
	fi
fi



init_size=$((2048))
#declare -i increase_size=19531250 #9.3G
increase_size=$((size_gb * 1024 * 1024 * 1024 / 512)) #9.3G
#Information: Moved requested sector from 18874369 to 18876416 in
#order to align on 2048-sector boundaries.

#exit 19
#  GPT partition

sudo sgdisk -Z $disk
sudo sgdisk -og $disk

sudo sgdisk -n 1:$init_size:$increase_size       -c 1:"journal1" -t 1:8300 $disk  #9.3G 


partn=1
while [  $partn -lt $((total_partition + 1)) ]; do
      #echo The partn is $partn
      n=$((partn))
      startn=$((endn + 1)) 
	  endn=$((increase_size * $partn))
	  #echo "sudo sgdisk -n $n:$startn:$endn        -c $n:'journal'$n -t $n:8300 $disk"  #9.3G
	  sudo sgdisk -n $n:$startn:$endn        -c $n:'journal'$n -t $n:8300 $disk  #9.3G
	  let partn=partn+1 
done

END=`sudo sgdisk -E $disk`
#sudo sgdisk -2 2:$increase_size:$END     -c 2:"journaln" -t 2:8300 $disk  # ...
sudo sgdisk -p $disk
echo 
ls -al $disk*
#Number  Start (sector)    End (sector)  Size       Code  Name
#   1            2048        19531250   9.3 GiB     8300  journal
#   2        19531776        20146175   300.0 MiB   8300  Linux filesystem
#   3        20146176        20760575   300.0 MiB   8300  Linux filesystem
#   4        21374976        21989375   300.0 MiB   8300  Linux filesystem
#   5        21989376        22603775   300.0 MiB   8300  Linux filesystem
#   6        22603776        23218175   300.0 MiB   8300  Linux filesystem

