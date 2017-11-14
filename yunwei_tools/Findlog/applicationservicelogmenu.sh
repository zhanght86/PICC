#!/bin/bash

SYSTEM_PRINT()  #--������־�������
{
if [ "$2" -ge "$System_Print_Flag" ]
then
                echo "$1"
else
                echo "-"
fi
}

echo `SYSTEM_PRINT "**************************************<start_Linux_applicationservicelogmenu.sh>**************************************" "1" ;`
. $Linux_MainPath/Linux_init_function.sh                                                                                                                    #--�������躯��


Linux_ApplicationServiceLogMenu_Path="$Linux_MainPath/shs/applicationservicelog_sh"                                                                                                                        #--����Linux��ά���˵�·��
echo `SYSTEM_PRINT "Linux_ApplicationServiceLogMenu_Path: $Linux_ApplicationServiceLogMenu_Path" "1" ;`

Linux_ApplicationServiceLogMenu_File="applicationservicelogmenu.txt"                                                                                                                        #--����Linux��ά���˵������ļ�
echo `SYSTEM_PRINT "Linux_ApplicationServiceLogMenu_File: $Linux_ApplicationServiceLogMenu_File" "1" ;`

Linux_ApplicationServiceLogMenu_Flag="<applicationservicelogmenu>"                                                                                                                              #--����Linux��ά���˵�������ʶ
echo `SYSTEM_PRINT "Linux_ApplicationServiceLogMenu_Flag: $Linux_ApplicationServiceLogMenu_Flag" "1" ;`

i=1
while [ "$i" -eq 1 ]
do
echo "########################################################################################################################"
echo ps -ef|grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|awk '{print $2 " " $3}'                                                            #--��ȡ�˵�
echo "########################################################################################################################"

read Menu_Command                                                                                                                               #--��ȡ����Ĳ�������

if [ -n "$Menu_Command" ] && [ $Menu_Command = "0" ]                                                                                            #--����������Ϊ0ʱ��
then
    echo_print1=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ���˷�����һ��˵�"
    echo `SYSTEM_PRINT "$echo_print1" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
    i=0
elif [ -n "$Menu_Command" ] && [ `grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep -c "<$Menu_Command>"` = "1" ]                           #--����������Ϊ��Ч���ݵ�ʱ��
then
    Check_User_Type=`grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep "<$Menu_Command>"|awk '{print $4}'`                                  #--������������Ȩ�޼���
    Check_User_Type=`echo ${Check_User_Type#*\<type}`
    Check_User_Type=`echo ${Check_User_Type%\>}`
    echo `SYSTEM_PRINT "Check_User_Type: $Check_User_Type" "1" ;`
    echo `SYSTEM_PRINT "User_Type: $User_Type" "1" ;`

    if [ "$User_Type" -ge "$Check_User_Type" ]                                                                                                  #--���û�Ȩ�޴��ڵ��ڴ˲���Ȩ
    then
        NextMessage=`grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep "<$Menu_Command>"`
        echo_print3=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ����"`echo $NextMessage|awk '{print $3}'`""
        echo `SYSTEM_PRINT "$echo_print3" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
        NextPath=`echo $NextMessage|awk '{print $5}'`
        NextFile=`echo $NextMessage|awk '{print $6}'`

        echo `SYSTEM_PRINT "#sh $Linux_ApplicationServiceLogMenu_Path$NextPath/$NextFile" "2" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
        sh $Linux_ApplicationServiceLogMenu_Path$NextPath/$NextFile                                                                                                     #--������һ������
    elif [ "$User_Type" -lt "$Check_User_Type" ]                                                                                                #--���û�Ȩ��С��˲���Ȩ��
    then
        i=1
        echo_print4=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">�������û�Ȩ�޼�����ͣ�����ʹ�ô˹��ܣ�"
        echo `SYSTEM_PRINT "$echo_print4" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
    else                                                                                                                                        #--��Ȩ�޼����쳣��ʱ��
        echo_print5=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">��Ȩ�޳�����Ҫ��ϵ�����ߣ�"
        echo `SYSTEM_PRINT "$echo_print5" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
    fi
elif [ -n "$Menu_Command" ] && [ `grep $Linux_ApplicationServiceLogMenu_Flag $Linux_ApplicationServiceLogMenu_Path/$Linux_ApplicationServiceLogMenu_File|grep -c "<$Menu_Command>"` = "0" ]                           #--����������Ϊ��Ч���ݵ�ʱ��
then
    i=1
    echo_print6=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">���������������\"<$Menu_Command>\"������Ч�Ĳ������������ѡ��:"
    echo `SYSTEM_PRINT "$echo_print6" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
else                                                                                                                                            #--�������������쳣��ʱ��
    i=1
    echo_print7=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">���˵��������������Ҫ��ϵ�����ߣ�"
    echo `SYSTEM_PRINT "$echo_print7" "3" ;` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
fi
done
echo `SYSTEM_PRINT "**************************************<end_Linux_applicationservicelogmenu.sh>**************************************" "1";`
