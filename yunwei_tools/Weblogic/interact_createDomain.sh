#!/usr/bin/bash
#coding:utf-8

#初始化变量
#directory
BASE_DIR=$(cd `dirname $0`;pwd)
SHELL_NAME=`basename $0`
ORACLE_HOME=${HOME}/Oracle/Middleware/wlserver_10.3
TEMPLATE_DIR=${BASE_DIR}/templates
TMP_DIR=${BASE_DIR}/tmp                                                     #存放临时生成的wlst scripts
LOG_DIR=${BASE_DIR}/logs
RESTART_DIR=${HOME}/yunwei/restart_shell

IP=`ip add list dev eth0|grep global|awk '{print $2}'|awk -F / '{print $1}'`
suffix1=`echo ${IP}|awk -F . '{print $3}'`
suffix2=`echo ${IP}|awk -F . '{print $4}'`

#template files
TEMPLATE_CREATE_FILE=${TEMPLATE_DIR}/createDomainTemplate.py                #主管创建脚本模板
TEMPLATE_ADMINSTART_FILE=${TEMPLATE_DIR}/adminServerStartTemplate.sh        #主管启动脚本模板
TEMPLATE_SERVERRESTART_FILE=${TEMPLATE_DIR}/restartTemplate.sh              #server重启脚本模板
TEMPLATE_CREATE_MANAGESERVER=${TEMPLATE_DIR}/createManageServerTemplate1.py #受管创建脚本模板
TEMPLATE_MANAGESTART_FILE=${TEMPLATE_DIR}/manageServerStartTemplate.sh      #受管启动脚本模板


#调用weblogic函数脚本
. ${BASE_DIR}/weblogic_func.sh

#检查模板文件是否存在
fileIsExist ${TEMPLATE_CREATE_FILE}
fileIsExist ${TEMPLATE_ADMINSTART_FILE}
fileIsExist ${TEMPLATE_SERVERRESTART_FILE}
fileIsExist ${TEMPLATE_CREATE_MANAGESERVER}
fileIsExist ${TEMPLATE_MANAGESTART_FILE}
createPath ${TMP_DIR}
createPath ${LOG_DIR}
createPath ${RESTART_DIR}

#先询问创建主管还是受管
logging "创建主管请输入'0',创建受管请输入'1'"
read mode

if [ $mode == "0" ]
	then
	loggings "您选择了创建Weblogic主管，创建Weblogic AdminDomain需要以下信息！"
	sleep 2
	while true
	do
	#输入Domain名称
		while true
		do
			echo "请输入Domain名称,参考名：clubdomain>:"
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
	 	adminserver=${domainname%domain*}server_${suffix1}_${suffix2}_${adminport}
			
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
			then continue
		elif [ $createFlag == 'yes' ]
	
	#修改Domain创建模版文件  HOME SERVER_NAME PORT MODE  DOMAIN_NAME
			then
			sed -e "s:HOME:$HOME:g" -e "s/ADMIN_SERVER/$adminserver/g" -e "s/PORT/$adminport/g" -e "s/MODE/$domainmode/g" -e "s/DOMAIN_NAME/$domainname/g" /${TEMPLATE_CREATE_FILE} > ${TMP_DIR}/create${domainname}.py
			echo "createDomainTemplate file is finished!"
			logging "template文件内容为："
			catlog ${TMP_DIR}/create${domainname}.py
			logging "------------------end!"
				
	#开始创建Domain
			sh ${ORACLE_HOME}/common/bin/wlst.sh ${TMP_DIR}/create${domainname}.py
	
			#在$Domain_Home/bin目录下添加启动脚本
			sed -e "s/DOMAIN_NAME/$domainname/g" -e "s/ADMIN_PORT/$adminport/g" -e "s/SERVER_NAME/$adminserver/g" -e "s/MEMORY/512/g" /${TEMPLATE_ADMINSTART_FILE} > $HOME/bea/user_projects/domains/${domainname}/bin/${adminserver}_start.sh
			logging "添加主管启动脚本end！"
			#在$HOME/yunwei/restart_shell目录下添加重启脚本
			sed -e "s/SERVER_NAME/$adminserver/g" -e "s/DOMAIN_NAME/$domainname/g" ${TEMPLATE_SERVERRESTART_FILE} > ${RESTART_DIR}/${adminserver}_restart.sh
			logging "添加重启脚本end！"
			exit 0
		else
			echo "为什么不按我说的输呢?"
			exit 0
		fi
	done
	#Create Weblogic Admin Domain end ---------------------

elif [ $mode == "1" ]
	then
	logging "开始准备受管创建脚本及受管启动脚本..........."
	while true
	do
		while true
		do
		logging "请输入主管名称："
		read domainname
		if [ -d "${HOME}/bea/user_projects/domains/${domainname}" ]
			then break
		else
			logging "您输入的domain不存在，请重新输入！"
			continue
		fi
		done

		while true
		do
			logging "请输入主管端口："
			read adminport
			start=1024
			end=65536
			if [ $adminport -lt $start ] || [ $adminport -gt $end ]
				then logging "端口号不在${start}和${end}之间，请重新输入！"
				continue
			else
				logging "端口号${adminport}在${start}和${end}之间!"
				break
			fi
		done

		while true
		do
			logging "请输入受管端口："
			read serverport
			checkIsNum $serverport
			checkPortRange $serverport
			checkPortInUse $serverport			
		done

		logging "请输入受管启动内存大小(值为数字,如1024、2048....):"
		read servermory

		logging "请输入主管IP,若为本机IP则按enter跳过："
		read adminIP

		manageserver=${domainname%domain*}server_${suffix1}_${suffix2}_${serverport}

		logging "以下为Domain信息："
		logging "Domain name is $domainname."
		logging "Domain port is $adminport."
		logging "Server port is $serverport."
		logging "Server name is $manageserver."
		logging "adminIP is $adminIP."
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
			then continue
		elif [ $createFlag == 'yes' ]
			then
			#创建受管启动脚本和wlst脚本
			if [ -n "$adminIP" ]
				then
				sed -e "s/DOMAIN_NAME/${domainname}/g" -e "s/ADMIN_PORT/${adminport}/g" -e "s/SERVER_NAME/${manageserver}/g" -e "s/SERVER_PORT/${serverport}/g" -e "s/MEMORY/${servermory}/g" -e "21a IP=$adminIP" ${TEMPLATE_MANAGESTART_FILE} > $HOME/bea/user_projects/domains/${domainname}/bin/${manageserver}_start.sh	
				sed -e "s/ADMIN_PORT/${adminport}/g" -e "s/MANAGE_SERVER/${manageserver}/g" -e "s/SERVER_PORT/${serverport}/g" -e "s/localhost/$adminIP/g" ${TEMPLATE_CREATE_MANAGESERVER} > ${TMP_DIR}/create_${manageserver}.py
			else
				sed -e "s/DOMAIN_NAME/${domainname}/g" -e "s/ADMIN_PORT/${adminport}/g" -e "s/SERVER_NAME/${manageserver}/g" -e "s/SERVER_PORT/${serverport}/g" -e "s/MEMORY/${servermory}/g" ${TEMPLATE_MANAGESTART_FILE} > $HOME/bea/user_projects/domains/${domainname}/bin/${manageserver}_start.sh	
				sed -e "s/ADMIN_PORT/${adminport}/g" -e "s/MANAGE_SERVER/${manageserver}/g" -e "s/SERVER_PORT/${serverport}/g" ${TEMPLATE_CREATE_MANAGESERVER} > ${TMP_DIR}/create_${manageserver}.py
			
			fi				
			logging "受管启动脚本创建完毕"
			logging "manageserver start shell is finished!"
			#创建受管wlst脚本	
			logging "manageserver create script is finished!"
			logging "创建受管的脚本在${TMP_DIR}目录下，必须先启主管才能创建受管，别忘记执行哟！"

			#添加重启脚本
			sed -e "s/SERVER_NAME/$manageserver/g" -e "s/DOMAIN_NAME/$domainname/g" ${TEMPLATE_SERVERRESTART_FILE} > ${RESTART_DIR}/${manageserver}_restart.sh
			logging "$HOME/yunwei/restart:重启脚本创建完毕 ！"
			exit 0

		else 
			echo "为什么不按我说的输呢?"
			continue 
		fi
	done
	#Create ManageServer end ------------------

else
	logging "您既不想创建主管也不想创建受管吗？拜拜！"
	continue
fi
