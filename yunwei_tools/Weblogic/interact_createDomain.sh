#!/usr/bin/bash
#coding:utf-8

#初始化变量
LOG_DIR=./logs
SHELL_NAME=$0
ORACLE_HOME=$HOME/Oracle/Middleware/wlserver_10.3
TEMPLATE_DIR=./templates
TEMPLATE_CREATE=createDomainTemplate.py
TEMPLATE_ADMINSTART=adminServerStartTemplate.sh
TEMPLATE_SERVERRESTART=restartTemplate.sh
TMP_DIR=./tmp



#调用weblogic函数脚本
. ./weblogic_func.sh

loggings "开始创建Weblogic Domain！"
init=true
while [ $init == 'true' ]
do
#输入Domain名称
	while true
	do
		echo "开始创建Weblogic Domain了，请输入Domain名称,参考名：clubdomain>:"
		read domainname
		checkDominName $domainname
	done

#输入Domain模式
	while true
	do
		echo "请输入Domain模式, 'prod' or 'dev'>:"
		read domainmode
		checkDomainMode $domainmode
	done

#输入Domain端口号
	while true
	do
		echo "请输入当前Domain的端口号>:"
		read adminport
		checkIsNum $adminport
		checkPortRange $adminport
		checkPortInUse $adminport
	done

#主管server name
 	adminserver=${domainname%domain*}server_${adminport}
		
#输出domain信息
	#echo  Domain name is $domainname.
	#echo  Domain mode is $domainmode.
	#echo  Server port is $adminport. 
	#echo  Server name is $adminserver.
	#echo  Console user is weblogic.
	#echo  Console pswd is weblogic1234.
	logging "以下为Domain信息："
	logging "Domain name is $domainname."
	logging "Domain mode is $domainmode."
	logging "Server port is $adminport."
	logging "Server name is $adminserver."
	logging "Console user is weblogic."
	logging "Console pswd is weblogic1234."
	logging "------------------"

	logging "  输入：'yes'-确认创建  'no'-重新创建  'exit'-退出"

#确认是否创建	
	read createFlag
	logging "${createFlag}"
	logging "------------------"
	
	if [ $createFlag == 'exit' ]
		then exit 0
	elif [ $createFlag == 'no' ]
		then init=true
	elif [ $createFlag == 'yes' ]
		then

#修改Domain创建模版文件  HOME SERVER_NAME PORT MODE  DOMAIN_NAME
		if [ -f ${TEMPLATE_DIR}/${TEMPLATE_CREATE} ]
			then sed -e "s:HOME:$HOME:g" -e "s/ADMIN_SERVER/$adminserver/g" -e "s/PORT/$adminport/g" -e "s/MODE/$domainmode/g" -e "s/DOMAIN_NAME/$domainname/g" ${TEMPLATE_DIR}/${TEMPLATE_CREATE} > ${TMP_DIR}/create${domainname}.py
			echo "createDomainTemplate file is finished!"
			logging "template文件内容为："
			catlog ${TMP_DIR}/create${domainname}.py
			logging "------------------end!"
			
		else
			echo "The createDomainTemplate is missing!"
			exit 0
		fi
#开始创建Domain
		sh ${ORACLE_HOME}/common/bin/wlst.sh ${TMP_DIR}/create${domainname}.py

		#在$Domain_Home/bin目录下添加启动脚本
		sed -e "s/DOMAIN_NAME/$domainname/g" -e "s/ADMIN_PORT/$adminport/g" -e "s/SERVER_NAME/$adminserver/g" -e "s/MEMORY/512M/g" ${TEMPLATE_DIR}/${TEMPLATE_ADMINSTART} > $HOME/bea/user_projects/domains/${domainname}/bin/${adminserver}_start.sh
		logging "添加主管启动脚本end！"
		#在$HOME/yunwei/restart_shell目录下添加重启脚本
		createPath ${HOME}/yunwei/restart_shell
		sed -e "s/SERVER_NAME/$adminserver/g" -e "s/DOMAIN_NAME/$domainname/g" ${TEMPLATE_DIR}/${TEMPLATE_SERVERRESTART} > ${HOME}/yunwei/restart_shell/${adminserver}_restart.sh
		logging "添加重启脚本end！"
		exit 0
	else
		echo "为什么不按我说的输呢?"
		exit 0
	fi
done
