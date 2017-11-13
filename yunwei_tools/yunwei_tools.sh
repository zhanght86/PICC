#!/usr/bin/env bash
#coding:utf-8
#yunwei_tools main menu

YUNWEI_HOME=$(cd `dirname $0`;pwd)
SHELL_NAME=`basename $0`
EPICC_FUNCTION=${YUNWEI_HOME}/epicc_function.sh
. ${EPICC_FUNCTION}

LOG_DIR=${YUNWEI_HOME}/logs
createPath ${LOG_DIR}
RESTART_DIR=${HOME}/yunwei/restart_shell

export YUNWEI_HOME SHELL_NAME LOG_DIR EPICC_FUNCTION RESTART_DIR

MAIN_MENU=${YUNWEI_HOME}/mainmenu.txt
fileIsExist ${MAIN_MENU}

echo "**************************************<start_Yunwei_Tools_mainmenu>**************************************"
echo "===================================================================================================="
echo "|          @@@@@@@@@@@           @@@@@@@@@@@           @@@@@@@@@@@           @@@@@@@@@@@           |"
echo "|          @         @                @                @                     @                     |"
echo "|          @         @                @                @                     @                     |"
echo "|          @         @                @                @                     @                     |"
echo "|          @         @                @                @                     @                     |"
echo "|          @         @                @                @                     @                     |"
echo "|          @         @                @                @                     @                     |"
echo "|          @@@@@@@@@@@                @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                          @                @                     @                     |"
echo "|          @                     @@@@@@@@@@@           @@@@@@@@@@@           @@@@@@@@@@@           |"
echo "===================================================================================================="
logging "您正在使用运维工具，请先进行登录^_^!"
logging "请输入您的账号:"
read username "OHCE"
loggings "$username"
logging "请输入您的密码:"
stty -echo
read password
stty echo
loggings "$password" "OHCE"

checkLogin ${username} ${password}
logging "您好,尊敬的用户<""$User_Name"">,请根据下列菜单进行操作:"

while true
do
    echo "########################################################################################################################"
    sed '/^#/d' ${MAIN_MENU}|awk '{print $1 $2}'
    echo "########################################################################################################################"
    echo "----------请输入编号,退出请按0----------"
    read choice
    #awk -v value=\<$a\> '{if($1 == value) {system("sh xxx.sh")}}' mainmenu.txt
    if [ -n "$choice" ] 
        then
        if [ "$choice" == 0 ]
            then 
            logging "您选择了退出，谢谢使用！"
            exit 0
        elif  [ `awk '{print $1}' ${MAIN_MENU}|grep -c "<$choice>" ` = "1" ]
            then script=`grep "<$choice>" ${MAIN_MENU}|awk '{print $4}'`
            logging "您选择了$choice,开始执行${YUNWEI_HOME}/${script}！"
            sh ${YUNWEI_HOME}/${script}
        else
            logging "为啥不按我说的输呢？"
        fi
    fi
done