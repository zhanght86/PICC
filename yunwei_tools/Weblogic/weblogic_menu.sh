#!/usr/bin/env bash
#coding:utf-8

. ${EPICC_FUNCTION}
BASE_DIR=$(cd `dirname $0`;pwd)

WEBLOGIC_MENU=${BASE_DIR}/weblogic_menu.txt
fileIsExist ${WEBLOGIC_MENU}

while true
do
    echo "########################################################################################################################"
    sed '/^#/d' ${WEBLOGIC_MENU}|awk '{print $1 $2}'
    echo "########################################################################################################################"
    echo "----------请输入编号,返回上一级请按0----------"
    read choice
    if [ $choice = "0" ]
        then break
    elif [ `awk '{print $1}' ${WEBLOGIC_MENU}|grep -c "<$choice>" ` = "1" ]
        then 
        script=`grep "<$choice>" ${WEBLOGIC_MENU}|awk '{print $4}'`
        logging "您选择了$choice,开始执行${BASE_DIR}/${script}！"
        sh ${BASE_DIR}/${script}
    else 
        logging "为啥不按提示的输呢？"
    fi
done

