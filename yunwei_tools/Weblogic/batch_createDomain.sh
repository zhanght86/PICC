#!/usr/bin/bash
#coding:utf-8

#初始化变量
#directory
BASE_DIR=$(cd `dirname $0`;pwd)
SHELL_NAME=`basename $0`
ORACLE_HOME=${HOME}/Oracle/Middleware/wlserver_10.3
TEMPLATE_DIR=${BASE_DIR}/templates
TMP_DIR=${BASE_DIR}/tmp                                                          #存放临时生成的文件
RESTART_DIR=${HOME}/yunwei/restart_shell
LOG_DIR=${BASE_DIR}/logs

#template files
TEMPLATE_CREATE_MESSAGE=${TEMPLATE_DIR}/createMessage.txt                        #批量创建Domain配置文件
TEMPLATE_CREATE_FILE=${TEMPLATE_DIR}/createDomainTemplate.py                     #主管创建脚本模板
TEMPLATE_CREATE_MANAGESERVER=${TEMPLATE_DIR}/createManageServerTemplate1.py      #受管创建脚本模板
TEMPLATE_ADMINSTART_FILE=${TEMPLATE_DIR}/adminServerStartTemplate.sh             #主管启动脚本模板
TEMPLATE_MANAGESTART_FILE=${TEMPLATE_DIR}/manageServerStartTemplate.sh           #受管启动脚本模板
TEMPLATE_SERVERRESTART_FILE=${TEMPLATE_DIR}/restartTemplate.sh                   #server重启脚本模板

TMP_CREATE_MESSAGE=${TMP_DIR}/createMessage$(date +%Y%m%d_%H:%M).txt             #临时配置文件


#调用weblogic函数脚本
. ${BASE_DIR}/weblogic_func.sh
#判断文件是否存在
fileIsExist ${TEMPLATE_CREATE_MESSAGE} 
fileIsExist ${TEMPLATE_CREATE_FILE}
fileIsExist $TEMPLATE_CREATE_MANAGESERVER
fileIsExist $TEMPLATE_ADMINSTART_FILE
fileIsExist $TEMPLATE_MANAGESTART_FILE
fileIsExist $TEMPLATE_SERVERRESTART_FILE
createPath ${TMP_DIR}
createPath ${LOG_DIR}
createPath ${RESTART_DIR}

#添加一个判断是否执行此脚本
if [ ! -n "${BATCH_CREATE}" ]
	then logging "请设置BATCH_CREATE变量！"
	exit 0
elif [ "${BATCH_CREATE}" == "true" ]
	then

	#删除配置文件前四行注释
	echo "-----------------------"
	if [ `uname` == 'AIX' ]
		then
		sed '1,4d' ${TEMPLATE_CREATE_MESSAGE}|sed '/^ $/d' > ${TMP_CREATE_MESSAGE}
	else
		sed '1,4d' ${TEMPLATE_CREATE_MESSAGE}|sed '/^\s$/d' > ${TMP_CREATE_MESSAGE}
	fi
	
	logging "开始读取配置文件"
	while read line
	do 
		#初始化一个数组，将每行的字段保存在一个数组里面
		n=0
		declare -a domsg
		for i in `echo $line`
		do
			domsg[$n]=$i
			n=`expr $n + 1`
		done
		logging "**************配置文件信息如下***********************"
		logging "${domsg[*]}"
		if [ ${domsg[0]} == 'admin' ]
			then logging "开始创建WLST domain模板！"
			domainname=${domsg[1]}
			domainport=${domsg[2]}
			domainmode=${domsg[3]}
			domainmory=${domsg[5]}
			adminserver=${domainname%domain*}server_${domainport}

			logging	"Domain name is ${domsg[1]}!"
			logging	"Domain port is ${domsg[2]}!"
			logging	"Domain mode is ${domsg[3]}!"
			logging	"Admin server is $adminserver!"	

			checkIsNumBatch $domainport
			checkDomainModeBatch $domainmode
	
			sed -e "s:HOME:$HOME:g" -e "s/DOMAIN_NAME/$domainname/g" -e "s/ADMIN_SERVER/$adminserver/g" -e "s/PORT/$domainport/g" -e "s/MODE/$domainmode/g"  ${TEMPLATE_CREATE_FILE} > ${TMP_DIR}/create${domsg[1]}.py 
			logging "createDomainTemplate file is finished!"
			logging "-----------------------"
	
			sh ${ORACLE_HOME}/common/bin/wlst.sh ${TMP_DIR}/create${domsg[1]}.py 
			logging "Domain 创建完毕！"
	
			sed -e "s/DOMAIN_NAME/$domainname/g" -e "s/ADMIN_PORT/$domainport/g" -e "s/SERVER_NAME/$adminserver/g" -e "s/MEMORY/${domainmory}/g" ${TEMPLATE_ADMINSTART_FILE} > $HOME/bea/user_projects/domains/${domainname}/bin/${adminserver}_start.sh
			logging "主管启动脚本创建完毕！"
			
			sed -e "s/SERVER_NAME/$adminserver/g" -e "s/DOMAIN_NAME/$domainname/g" ${TEMPLATE_SERVERRESTART_FILE} > ${RESTART_DIR}/${adminserver}_restart.sh
			logging "$HOME/yunwei/restart:重启脚本创建完毕 ！"		
	
		elif [ ${domsg[0]} == 'manage' ]
			then logging "开始创建受管启动脚本！"
			domainname=${domsg[1]}
			domainport=${domsg[2]}
			serverport=${domsg[4]}
			#servermory=${domsg[5]}
			servermory=`echo ${domsg[*]}|awk '{print $6}'`
			manageserver=${domainname%domain*}server_${serverport}

			logging	"Domain name is $domainname."
			logging	"Domain port is $domainport."
			logging	"Server name is $manageserver."
			logging	"Server port is $serverport."
			logging	"Server memory is $servermory!"
	
			checkIsNumBatch $serverport
	
			sed -e "s/DOMAIN_NAME/${domainname}/g" -e "s/ADMIN_PORT/${domainport}/g" -e "s/SERVER_NAME/${manageserver}/g" -e "s/SERVER_PORT/${serverport}/g" -e "s/MEMORY/${servermory}/g" ${TEMPLATE_MANAGESTART_FILE} > $HOME/bea/user_projects/domains/${domainname}/bin/${manageserver}_start.sh	
			logging "受管启动脚本创建完毕"
			logging "manageserver start shell is finished!"
	
			sed -e "s/SERVER_NAME/$manageserver/g" -e "s/DOMAIN_NAME/$domainname/g" ${TEMPLATE_SERVERRESTART_FILE} > ${RESTART_DIR}/${manageserver}_restart.sh
			logging "$HOME/yunwei/restart:重启脚本创建完毕 ！"
	
			sed -e "s/ADMIN_PORT/${domainport}/g" -e "s/MANAGE_SERVER/${manageserver}/g" -e "s/SERVER_PORT/${serverport}/g" ${TEMPLATE_CREATE_MANAGESERVER} > ${TMP_DIR}/create_${manageserver}.py
			logging "manageserver create script is finished!"
			logging "创建受管的脚本在${TMP_DIR}目录下，必须先启主管才能创建受管，别忘记执行哟！"
	
		else 
			logging "Domain 创建信息配置错误，请检查后重新再试！"
		fi
	done < ${TMP_CREATE_MESSAGE}

else
	logging "BATCH_CREATE 值设置错误！"
fi

