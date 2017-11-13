#!/usr/bin/env bash
#coding:utf-8

#日志记录
#显示并保存（会判断上次命令的返回值）
function logging () {
    if [ $? == 0 ];
    then
        echo $(date '+%Y%m%d %H:%M:%S') $1 |tee -a ${LOG_DIR}/${SHELL_NAME}.log
    else
        echo $(date '+%Y%m%d %H:%M:%S') $1 failed!|tee -a ${LOG_DIR}/${SHELL_NAME}.log
    fi
}

#按传入的参数决定日志的输出
function loggings () {
    if [ "$2" == "OHCE" ]
        then
        echo $(date '+%Y%m%d %H:%M:%S') $1 >> ${LOG_DIR}/${SHELL_NAME}.log
    fi
}

#判断文件是否存在
function fileIsExist () {
    if [ ! -f $1 ]
        then logging "the $1 is not exist, please check it!"
        exit 0
    fi
}

#创建目录函数
function createPath() {
    if [ -d $1 ]
    then
        logging "$1 is exist!"
    else
        mkdir -p $1
    fi
}

#检查用户名密码
function checkLogin() {
    fileIsExist ${YUNWEI_HOME}/shadow.class
    user=`echo $1|base64 -i`
    pawd=`echo $2|base64 -i`
    judge=`sed '/^#/d' ${YUNWEI_HOME}/shadow.class | grep -c "$user_$pawd"`
    if [ $judge == 1 ]
        then
        logging "您好,<""$1"">,欢迎使用运维小工具！"
    else
        logging "用户或密码错误，请重新输入！"
        exit 0
    fi
}