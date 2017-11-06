#!/usr/bin/env bash
#coding:utf-8
#retrieve system info
#create by harry
#time:2017-10-31

if [ `uname` == "Linux" ]
then
    cpu_n=`grep processor /proc/cpuinfo|wc -l`
    echo "CPU核数为："$cpu_n

    cpu_m=`grep "model name" /proc/cpuinfo|awk -F : '{print $2}'|uniq -1`
    #grep "model name" /proc/cpuinfo|awk -F : '{print $2}'|uniq -c
    echo "CPU型号为："$cpu_m

    mem_s=`free -g|awk '{if (NR==2){print $2}}'`
    echo "Memory大小为："${mem_s}g

    swap_s=`free -g|awk '{if (NR==4){print $2}}'`
    echo "Swap大小为：" ${swap_s}g

    root_s=`df -h|sed -n '2,2p'|awk '{print $2}'`
    echo "根目录（/）大小为："$root_s

elif [ `uname` == "AIX" ];
then 
    #Application_Ip=`prtconf|grep "IP Address:"|awk -F ": " '{print $2}'`
    # Physical_Cpu=`lsdev -Cc processor|wc -l`
    cpu_n=`lparstat -i|grep -w "Online Virtual CPUs"|awk -F ": " '{print $2}'`
    #Virtual_Cpu=`vmstat|awk 'NR==2{print $3}'|awk -F "=" '{print $2}'`
    echo "CPU核数为："$cpu_n

    cpu_m=`prtconf|grep "Processor Type"|awk -F ": " '{print $2}'`
    echo "CPU型号为："$cpu_m

    mem_s=`lparstat -i|grep -w "Online Memory"|awk -F ": " '{print $2}'`
    # Physical_Memory=`bootinfo -r`
    echo "Memory大小为："${mem_s}

    swap_s=`prtconf|grep "Total Paging Space"|awk -F ": " '{print $2}'`
    #Swap_Space=`lsps -s|grep MB|awk -F "MB" '{print $1}'`
    echo "Swap大小为：" ${swap_s}

    root_s=`df -g|sed -n '2,2p'|awk '{print $2}'`
    echo "根目录（/）大小为："${root_s}g
fi