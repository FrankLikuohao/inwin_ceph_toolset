#!/bin/bash  
########################################################################
#This is a test plan for test the ceph performance in target directory #
#Usage testplan.sh   /mnt/rbd                                          #
#Designed by Frank Li 2016/08/10                                       #
########################################################################
if (( $# != 1 )); then
    echo "Usage: $0 directory"
    echo "test plan for Ceph rbd/cephfs directory"
    echo "ex: $0 /mnt/rbd"
    echo "Frank Li 2016/08/10"
    exit 1
fi

directory=$1
cd $directory
if (($? != 0 )); then
        echo "chdir $directory error"
        exit 1
fi

clear
currentdir=`pwd`
echo "test the ceph directory [$currentdir]"
outputfile="$0.result"
echo "outputfile = [$currentdir/$outputfile]"
#-----------------------------------------------------------------------------------------------------------------------ryy
echo "test max write throughput"
#cmd="sudo dd if=/dev/zero of=./testfile bs=128k count=100000 oflag=direct"
cmd="sudo dd if=/dev/zero of=./testfile bs=128k count=100000 oflag=direct"
echo $cmd

date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S" &>$outputfile
echo "test max write throughput" &>>$outputfile
echo "$cmd" &>>$outputfile
$cmd &>>$outputfile
cat $outputfile

#-----------------------------------------------------------------------------------------------------------------------yy
echo "test max read throughput"
#clear cache
sudo echo 3 | sudo tee /proc/sys/vm/drop_caches && sudo sync
cmd="sudo dd of=/dev/null if=./testfile bs=128k"
echo $cmd
date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S" &>>$outputfile
echo "test max read throughput" &>>$outputfile
echo $cmd &>>$outputfile

$cmd  &>>$outputfile
cat $outputfile

#-----------------------------------------------------------------------------------------------------------------------yy
echo "test 4k random write iops"
#cmd="fio --filename=./testfile --direct=1 --rw=randwrite --bs=4k --size=10G --numjobs=32 --runtime=60 --group_reporting --name=testfile --output=./testfile --ioengine=libaio --iodepth=4 --loops=2"
cmd="fio --filename=./testfile --direct=1 --rw=randwrite --bs=4k --size=10G --numjobs=32 --runtime=60 --group_reporting --name=testfile --output=./testfile --ioengine=libaio --iodepth=4 --loops=2"
echo $cmd
$cmd &>>$outputfile
cat $outputfile

#-----------------------------------------------------------------------------------------------------------------------yy
echo "test 4k random read"
sudo echo 3 | sudo tee /proc/sys/vm/drop_caches && sudo sync
#cmd="fio --filename=./testfile --direct=1 --rw=randread -bs=4k --size=10G --numjobs=32 --runtime=60 --group_reporting --name=testfile --output=./testfile --ioengine=libaio --iodepth=4 --loops=2"
cmd="fio --filename=./testfile --direct=1 --rw=randread -bs=4k --size=10G --numjobs=32 --runtime=60 --group_reporting --name=testfile --output=./testfile --ioengine=libaio --iodepth=4 --loops=2"
echo $cmd
$cmd &>>$outputfile
cat $outputfile

#-----------------------------------------------------------------------------------------------------------------------yy
echo "test mix 64K random read/write (67%/33%)"
#cmd="fio --directory=./ -direct=1 -iodepth=1 -thread -rw=randrw -rwmixread=67 -ioengine=libaio -bs=64k -size=10G -numjobs=32 -runtime=100 -group_reporting -name=disk"
cmd="fio --directory=./ -direct=1 -iodepth=1 -thread -rw=randrw -rwmixread=67 -ioengine=libaio -bs=64k -size=10G -numjobs=32 -runtime=100 -group_reporting -name=disk"
echo $cmd
$cmd &>>$outputfile
cat $outputfile




#-----------------------------------------------------------------------------------------------------------------------yy
echo "fio $Action=read, write, randread, randwrite - $bs=4k,128k,8m test"
for bs in 4k 128k 8m; do
        for Action in read write randread randwrite; do
 OutputFile=$0.result.$bs.$Action
                #cmd="fio --directory=$directory --direct=1 --rw=$Action --bs=$bs --size=10G --numjobs=128 --runtime=60 --group_reporting --name=testfile --output=$OutputFile"
                cmd="fio --directory=$directory --direct=1 --rw=$Action --bs=$bs --size=10G --numjobs=128 --runtime=60 --group_reporting --name=testfile --output=$OutputFile"
                echo $cmd
                echo $cmd &>>$outputfile
                date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S" &>>$outputfile
                $cmd
                cat $OutputFile >> $outputfile
        done
done
cat $outputfile
