#!/bin/bash 
################################################################
#This is a script to remote prepare and activate the huge osds #
#go.sh                                         Frank Li 2015/03/17  #
################################################################           
if (( $# < 3 )); then
	echo "#############################################################################################################"
    echo "Usage: $0 remote_hostname skip_first_n_sd ssd_location (-r)"
    echo "ex: $0 hostname 2 /dev/sdd"
    echo "skip_first_n_sd: some /dev/sda /dev/sd2 are used by OS  data or ssd , so it need to skip first n disks, ex: 2"
    echo "ssd_location: the device name of ssd ex: /dev/sdd"
    echo "-r: no detection again and read remote notssdlist.txt file (id_ssd result)after modify the file"
    echo "                                                                                           Frank Li 2015/03/18"
    echo "###############################################################################################################"
    exit 1
fi

host=$1
skipsd=$2
ssd_location=$3


yes=$4
#check -r to read remote modified result or run id-ssd and go   
if [ -z $yes  ]; then 
	yes=0	
	#rcp id_ssd and run to get the notssdlist.txt
	id_ssd="./id-ssd"
	scp ./$id_ssd $host:~
	ssh -t $host "~/$id_ssd"
fi

if [ $yes = '-r' ]; then
	echo "read notssdlist.txt"
	ssh vmon1 "cat  notssdlist.txt"
	echo "right? (y/n)>"
		read ANSWER 
		#echo "$ANSWER"
	if (( $ANSWER != "y" )); then
		echo "Try input right parameters again!"
		exit 1
	fi
fi


SDX_ARR=($(\ssh vmon1 "cat  notssdlist.txt "))
for ((i=0; i<$skipsd; i++)); do unset SDX_ARR[$i]; done
echo ${SDX_ARR[@]}

SSD_ARR=($(\ssh vmon1 "ls -m $ssd_location* | tr ',' ' '| tr ':' ' '"))
unset SSD_ARR[0]
echo ${SSD_ARR[@]}
#unset arr[${#arr[@]}-1]



execfile=go.sh

if [ -f $execfile ];
then
   \rm -rf $execfile
   touch $execfile 
else
   touch $execfile 
fi

howmanyosd=${#SDX_ARR[@]}
echo "osd number = [$howmanyosd]"
for ((i=0; i<$howmanyosd; i++)); do 
	osdn=$i+$skipsd
	journaln=$i+1
	echo "ceph-deploy osd prepare $host:${SDX_ARR[$osdn]}:${SSD_ARR[$journaln]}" >> $execfile
	# ceph-deploy osd activate vmon1:/dev/sdc1:/dev/sdd1
	echo "ceph-deploy osd activate vmon1:${SDX_ARR[$osdn]}1:${SSD_ARR[$journaln]}" >>$execfile
done
chmod a+x $execfile
more $execfile
exit 0;


disk=$1
size_gb=$2
total_partition=$3
yes=$4
 ssh vmon1 ls -m /dev/sdb*
/dev/sdb, /dev/sdb1, /dev/sdb2, /dev/sdb3
