#!/usr/bin/bash
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

#判断domain名是否符合规范：${name}domain
function checkDominName () {
	n=$1
	if [ ${#n} -lt 7 ]
		then logging "Domin名不符合规范，建议使用'\${name}domain',如clubdomain"
		continue
	elif [ ! ${n:0-6} == "domain" ]
		then logging "Domin名不符合规范，建议使用'\${name}domain',如clubdomain"
		continue
	else
		logging "Domain Name is $n"
		break
	fi
}

#判断domain模式是否输入正确
function checkDomainMode () {
	if [ $1 == "prod" ] || [ $1 == "dev" ]
		then
		logging "Domain mode is $1,passed! "
		break
	else
		logging "您输入的Domain模式为 $1, 请重新输入！"
		continue
	fi
}

#判断domain模式是否输入正确（批量创建Domain脚本使用）
function checkDomainModeBatch () {
	if [ $1 == "prod" ] || [ $1 == "dev" ]
		then
		logging "Domain mode is $1,passed! "
	else
		logging "Domain模式填错 $1, 请检查！"
		exit 0
	fi
}

#检查输入是否为数字
function checkIsNum () {
	n=`echo $1|sed 's/[0-9]//g'|wc -c`
	if [ $n == 1 ]
		then logging "Server port is $1,passed!"	
	else
		logging "当前输入不为数字，请重新输入！"
		continue
	fi
}

#检查输入是否为数字（批量创建Domain脚本使用）
function checkIsNumBatch () {
	n=`echo $1|sed 's/[0-9]//g'|wc -c`
	if [ $n == 1 ]
		then logging "Server port is $1,passed!"	
	else
		logging "端口号不是数字 $1，请检查！"
		exit 0
	fi
}

#检查端口号是否在1024 ~ 65536之间且是否被
function checkPortRange () {
	start=1024
	end=65536
	if [ $1 -lt $start ] || [ $1 -gt $end ]
		then echo "端口号不在${start}和${end}之间，请重新输入！"
		continue
	else
		echo "端口号在${start}和${end}之间!"
	fi
}

#检查端口是否被占用
function checkPortInUse () {
	netstat -an|grep $1
	if [ $? == 0 ]
		then logging "The Port is in use, Please try another one!"
		continue
	else 
		logging "The Port is available!"
		break
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

#查看并保存
function catlog () {
	cat $1 |tee -a ${LOG_DIR}/${SHELL_NAME}.log
}


#判断文件是否存在
function fileIsExist () {
	if [ ! -f $1 ]
		then logging "the $1 is not exist, please check it!"
		exit 0
	fi
}

