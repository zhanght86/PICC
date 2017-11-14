#!/bin/bash

SYSTEM_PRINT()  #--定义日志输出函数
{
if [ "$2" -ge "$System_Print_Flag" ]
then
                echo "$1"
else
                echo "-"
fi
}

echo `SYSTEM_PRINT "**************************************<start_Linux_applicationservicelogmenu.sh>**************************************" "1" ;`
. $Linux_MainPath/Linux_init_function.sh                                                                                                                    #--调用所需函数


Linux_ApplicationServiceLogMenu_Path="$Linux_MainPath/shs/applicationservicelog_sh"                                                                                                                        #--定义Linux运维主菜单路径
echo `SYSTEM_PRINT "Linux_ApplicationServiceLogMenu_Path: $Linux_ApplicationServiceLogMenu_Path" "1" ;`

Linux_ApplicationServiceLogMenu_File="applicationservicelogmenu.txt"                                                                                                                        #--定义Linux运维主菜单配置文件
echo `SYSTEM_PRINT "Linux_ApplicationServiceLogMenu_File: $Linux_ApplicationServiceLogMenu_File" "1" ;`

Linux_ApplicationServiceLogMenu_Flag="<applicationservicelogmenu>"                                                                                                                              #--定义Linux运维主菜单搜索标识
echo `SYSTEM_PRINT "Linux_ApplicationServiceLogMenu_Flag: $Linux_ApplicationServiceLogMenu_Flag" "1" ;`

i=1
while [ "$i" -eq 1 ]
do
echo "########################################################################################################################"
echo ps -ef|grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|awk '{print $2 " " $3}'                                                            #--读取菜单
echo "########################################################################################################################"

read Menu_Command                                                                                                                               #--读取输入的操作代码

if [ -n "$Menu_Command" ] && [ $Menu_Command = "0" ]                                                                                            #--当操作代码为0时候
then
    echo_print1=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了返回上一层菜单"
    echo `SYSTEM_PRINT "$echo_print1" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
    i=0
elif [ -n "$Menu_Command" ] && [ `grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep -c "<$Menu_Command>"` = "1" ]                           #--当操作代码为有效内容的时候
then
    Check_User_Type=`grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep "<$Menu_Command>"|awk '{print $4}'`                                  #--定义操作代码的权限级别
    Check_User_Type=`echo ${Check_User_Type#*\<type}`
    Check_User_Type=`echo ${Check_User_Type%\>}`
    echo `SYSTEM_PRINT "Check_User_Type: $Check_User_Type" "1" ;`
    echo `SYSTEM_PRINT "User_Type: $User_Type" "1" ;`

    if [ "$User_Type" -ge "$Check_User_Type" ]                                                                                                  #--当用户权限大于等于此操作权
    then
        NextMessage=`grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep "<$Menu_Command>"`
        echo_print3=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了"`echo $NextMessage|awk '{print $3}'`""
        echo `SYSTEM_PRINT "$echo_print3" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
        NextPath=`echo $NextMessage|awk '{print $5}'`
        NextFile=`echo $NextMessage|awk '{print $6}'`

        echo `SYSTEM_PRINT "#sh $Linux_ApplicationServiceLogMenu_Path$NextPath/$NextFile" "2" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
        sh $Linux_ApplicationServiceLogMenu_Path$NextPath/$NextFile                                                                                                     #--进入下一层命令
    elif [ "$User_Type" -lt "$Check_User_Type" ]                                                                                                #--当用户权限小雨此操作权限
    then
        i=1
        echo_print4=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您的用户权限级别过低，不能使用此功能！"
        echo `SYSTEM_PRINT "$echo_print4" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
    else                                                                                                                                        #--当权限级别异常的时候
        echo_print5=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，权限出错，需要联系开发者！"
        echo `SYSTEM_PRINT "$echo_print5" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
    fi
elif [ -n "$Menu_Command" ] && [ `grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep -c "<$Menu_Command>"` = "0" ]                           #--当操作代码为无效内容的时候
then
    i=1
    echo_print6=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您所输入的命令\"<$Menu_Command>\"不是有效的操作命令，请重新选择:"
    echo `SYSTEM_PRINT "$echo_print6" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
else                                                                                                                                            #--操作代码内容异常的时候
    i=1
    echo_print7=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，菜单操作命令出错，需要联系开发者！"
    echo `SYSTEM_PRINT "$echo_print7" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
fi
done
echo `SYSTEM_PRINT "**************************************<end_Linux_applicationservicelogmenu.sh>**************************************" "1";`
