#!/usr/bin/env bash
#coding:utf-8

time=`date "+%Y%m%d_%H%M%S"`

YUNWEI_HOME=${HOME}/yunwei_tools
. ${YUNWEI_HOME}/epicc_function.sh

BASE_DIR=$(cd `dirname $0`;pwd)
SHELL_NAME=`basename $0`
LOG_DIR=${BASE_DIR}/logs

TELNET_MESSAGE=${BASE_DIR}/telnet_message.txt
TELNET_OK=${BASE_DIR}/telnet_ok.txt_$time
TELNET_FAIL=${BASE_DIR}/telnet_fail.txt_$time

fileIsExist ${TELNET_MESSAGE}
createPath ${LOG_DIR}

logging "telnet start..........."

counts=0
cat $TELNET_MESSAGE | while read line
do
    if [ -n "$line" ]
        then counts=`expr $counts + 1`
        ip=`echo $line |awk '{print $1}'`
        port=`echo $line|awk '{print $2}'`
        logging "开始telnet $ip $port"
        telnet $ip $port > ${BASE_DIR}/telnet.tmp &
        sleep 2
        pid=`ps -ef|grep telnet|grep $ip|awk '{print $2}'`
        kill -9 $pid
        ok=`grep Escape ${BASE_DIR}/telnet.tmp`
        if [ -n "$ok" ]
            then
            logging "$line is ok!"
            echo "$line is ok!" >> ${TELNET_OK}
        else
            logging "$line is fail!"
            echo "$line is fail!" >> ${TELNET_FAIL}
        fi
    fi
done

logging "telnet over.............., A total of ${counts}!"
echo "防火墙测试通过的结果在 ${telnet_ok}中，失败的在${telnet_fail}中，请记得查看！"
