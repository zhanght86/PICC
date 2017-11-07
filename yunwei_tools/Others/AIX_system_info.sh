#!/usr/bin/bash
#coding:utf-8

#host address
ip_addr=`ifconfig en0|awk '{if(NR==2){print $2}}'`

#numbers of logical cpu
lcpu_num=`lparstat -i|grep -w "Online Virtual CPUs"|awk -F ": " '{print $2}'`

#RAM size
ram_size=`vmstat|awk '{if(NR==2){print $4}}'|awk -F= '{print $2}'`

#Disk info
disk_num=`lsvg|wc -l`
if [ $disk_num -eq 1 ]
then
	disk1=`lsvg`
	disk1_size=`lsvg $disk1|grep "TOTAL PPs"|awk '{print $7}'|tr "(" '\0'`
	disk1_size=`expr $disk1_size / 1024 `

elif [ $disk_num -eq 2 ]
then
	disk1=`lsvg|head -1`
	disk2=`lsvg|tail -1`
	disk1_size=`lsvg $disk1|grep "TOTAL PPs"|awk '{print $7}'|tr "(" '\0'` 
	disk1_size=`expr $disk1_size / 1024 `
	disk2_size=`lsvg $disk2|grep "TOTAL PPs"|awk '{print $7}'|tr "(" '\0'`
	disk2_size=`expr $disk2_size / 1024 `

elif [ $disk_num -eq 3 ]
then
	disk1=`lsvg|head -1`
	disk2=`lsvg|head -2|tail -1`
	disk3=`lsvg|tail -1`
	disk1_size=`lsvg $disk1|grep "TOTAL PPs"|awk '{print $7}'|tr "(" '\0'`
	disk1_size=`expr $disk1_size / 1024 `
	disk2_size=`lsvg $disk2|grep "TOTAL PPs"|awk '{print $7}'|tr "(" '\0'`
	disk2_size=`expr $disk2_size / 1024 `
	disk3_size=`lsvg $disk3|grep "TOTAL PPs"|awk '{print $7}'|tr "(" '\0'`
	disk3_size=`expr $disk3_size / 1024 `

else [ $disk_num -gt 4 ] 
	disk_max="numbers of disk has more than three!"
fi 

echo $ip_addr $lcpu_num $ram_size $disk1_size 