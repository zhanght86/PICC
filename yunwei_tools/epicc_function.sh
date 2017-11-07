#!/usr/bin/env bash
#coding:utf-8

#日志记录
#显示并保存
function logging () {
    if [ $? == 0 ];
    then
        echo $(date '+%Y%m%d %H:%M:%S') $1 |tee -a ${LOG_DIR}/${SHELL_NAME}.log
    else
        echo $(date '+%Y%m%d %H:%M:%S') $1 failed!|tee -a ${LOG_DIR}/${SHELL_NAME}.log
    fi
}

#只保存不显示
function loggings () {
    echo $(date '+%Y%m%d %H:%M:%S') $1 >> ${LOG_DIR}/${SHELL_NAME}.log
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