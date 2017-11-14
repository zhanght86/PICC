#!/usr/bin/env bash
#coding:utf-8

#
LOGBF()
{
gzip -c  $domainfile/$logname > $logbak/${YESTERDAY}${logname}.gz
>$domainfile/$logname
echo "======================="
}

#YESTERDAY=`TZ=+16 date +%Y%m%d`
YESTERDAY=`date +%Y%m%d`
config=/home/ebss/yunwei/log_compression/log_gzip.txt

cat  $config |while read line  
do 
echo $line

judge=`echo $line |awk '{print $1}'`

if [ ${judge} = "yes" ];then

    domainname=`echo $line |awk '{print $2}'`
    logname=`echo $line |awk '{print $3}'`
    prot=`echo $line |awk '{print $4}'`
    domainfile=/log/${domainname}
    logbak=${domainfile}/LOG_BAK/${prot}
    
    if [ ! -d "$domainfile" ] ; then
        echo "file does not exist!"
    else
    
        if [ ! -d "$logbak" ] ;then
            mkdir -p $logbak
            echo "***"
            LOGBF &
        else
            LOGBF &
        fi 
    
    fi

fi 
done