#!/bin/bash
for i in {1..100}
do
    #dd if=/dev/urandom of="./testfile$(printf %d""$i)" bs=4k count=1280
    dd if=/dev/urandom of="./myobjects$i" bs=4k count=1280
    #dd if=/dev/urandom of="./myobjects_$(printf %d""$i)" bs=4k count=1280
    #echo hello > "File$(printf "%03d" "$i").txt"
done
