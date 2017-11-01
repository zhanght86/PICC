#!/bin/bash
#coding:utf-8

#字符集设置(According to system type)
System_Flag=`uname -s`
if [ "$System_Flag" == "AIX" ]
then
    LANG="Zh_CN.GB18030"
    echo $LANG
    export LANG
elif [ "$System_Flag" == "Linux" ]
then
    LANG="zh_CN.gb18030"
    echo $LANG
    export LANG
else
    echo "System is not AIX or Linux, the env LANG is default ${LANG}！"
fi

#需要定义的Domain信息
Domain_Name="DOMAIN_NAME"                         
Admin_Port="ADMIN_PORT"
Server_Name="SERVER_NAME"
Init_Username="weblogic"
Init_Password="weblogic1234"

#Domain相关的变量
Log_Name="/log/${Domain_Name}/${Server_Name}.log"
Domain_Path="${HOME}/bea/user_projects/domains/${Domain_Name}"
Server_Path="${Domain_Path}/servers/${Server_Name}"


#设置内存大小
Xms="MEMORY"
Xmx="MEMORY"
USER_MEM_ARGS="$USER_MEM_ARGS -Xms${Xms}m -Xmx${Xmx}m -XX:MaxPermSize=256m"
export USER_MEM_ARGS

#添加冲突jar包

#创建目录函数
createPath()
{
if [ -d $1 ]
then
    echo "$1 is exist!"
else
    mkdir -p $1
fi
}
#创建所需目录
createPath /log/${Domain_Name}                                         #Domain日志主路径
createPath ${Server_Path}/security                                     #创建密码文件路径    

#新建密码文件
if [ -f ${Server_Path}/security/boot.properties ]
then
    echo "boot.properties is ok!"
else
    echo "username=${Init_Username}" > ${Server_Path}/security/boot.properties
    echo "password=${Init_Password}" >> ${Server_Path}/security/boot.properties
fi


#清理缓存
echo "rm -rf $Server_Path/tmp/*!"
rm -rf $Server_Path/tmp/*
if [ -d $Cache_Path/stage ];
then 
	echo "rm -rf $Server_Path/stage/*"
	rm -rf ${Server_Path}/stage/*
else
	echo "Server Mode is no stage!"
fi

echo "缓存清理完毕!"


#启动命令
echo "准备启动受管服务，日志输出路径:"${Log_Name}""
cd $Domain_Path/bin
nohup sh startWebLogic.sh >> ${Log_Name} &
tail -f ${Log_Name}