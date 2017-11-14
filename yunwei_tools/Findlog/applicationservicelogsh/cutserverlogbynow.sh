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

echo `SYSTEM_PRINT "**************************************<start_Linux_mainmenu.sh>**************************************" "1" ;`

export Linux_MainPath="$MainPath/Linux"                                                                    #--����Linux��άС������·��
export LINUX_File_Tmp="$MainPath/Linux/shs/tmp"
echo `SYSTEM_PRINT "Linux_MainPath: $Linux_MainPath" "1" ;`
. $Linux_MainPath/Linux_init_function.sh                                                                        #--�������躯��

Find_Log_Config=$LINUX_File_Tmp/nowlog.txt
Log_File=`date +%Y""%m""%d""%H""%M""%S`".log"                                          #�������ļ���
Sed_Log_Path=/log/tmp_log/$Log_File

cat << FORE
##################################################################################################################################
<1> ʹ�ùؼ��ֽ�ȡ��־
<2> ʹ��ʱ��ν�ȡ��־
<0> ������һ��Ŀ¼
##################################################################################################################################
FORE
while true 
do

echo_print1=`SYSTEM_TIME;`"����ѡ���ȡ��־�ķ�ʽ�򷵻���һ��Ŀ¼:"
echo `SYSTEM_PRINT "$echo_print1" "3";`
read Log_Way

  if [ $Log_Way = "0" ]                                                                                         #ѡ��0��ʱ���˻��ϲ�Ŀ¼
  then
      echo_print2=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ���˷�����һ��Ŀ¼"
      echo `SYSTEM_PRINT "$echo_print2" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      exit 0

  elif [ $Log_Way = "1" ]                                                                                       #ѡ��1��ʱ��ʹ�ùؼ��ֽ�ȡ��־
  then
      echo_print3=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ����ʹ�ùؼ��ֽ�ȡ��־"
      echo `SYSTEM_PRINT "$echo_print3" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      
      
      
    
echo "##################################################################################################################################"
cat $Find_Log_Config
echo "<0> ������һ��Ŀ¼"
echo "##################################################################################################################################"

      while true                                                                                                #������Ϊ���ʱ��ִ�����²���
      do 
        echo_print4=`SYSTEM_TIME;`"����ѡ����־·�������кŻ򷵻���һ��Ŀ¼:"
        echo `SYSTEM_PRINT "$echo_print4" "3";`
        read Log_Number

        if [ $Log_Number = "0" ]                                                                                         #ѡ��0��ʱ���˻��ϲ�Ŀ¼
        then
            echo_print5=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ���˷�����һ��Ŀ¼"
            echo `SYSTEM_PRINT "$echo_print5" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
            exit 0
        else

    
            Check_Number=`grep -c "<$Log_Number>" $Find_Log_Config`                           #У��ѡ�����־·��������

            if [ $Check_Number = "1" ]                                                                              #��ѡ�����־·��������1��ʱ��,ִ�����²���
            then
                Log_Path=`grep "<$Log_Number>" $Find_Log_Config|awk '{print $2}'`                  #��־��·��
                echo_print6=`SYSTEM_TIME;`"��ѡ�����־·����:$Log_Path"
                echo `SYSTEM_PRINT "$echo_print6" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo_print8=`SYSTEM_TIME;`"������Ҫ��ȡ�Ĺؼ���:"
                echo `SYSTEM_PRINT "$echo_print8" "3";`
                read Key_Word
                echo_print9=`SYSTEM_TIME;`"��Ҫ��ȡ�Ĺؼ�����:<$Key_Word>"
                echo `SYSTEM_PRINT "$echo_print9" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                Grep_Number=`grep -n "$Key_Word" $Log_Path|wc -l`                                                   #ͳ�Ʋ鵽�Ĺؼ�������
                #echo $Grep_Number
                if [ $Grep_Number = "0" ]                                                                           #���ؼ��ֵ�����Ϊ0ʱ����ʾδ�ҵ�
                then
                    echo_print10=`SYSTEM_TIME;`"������Ĺؼ���<""$Key_Word"">δ�ҵ�"
                    echo `SYSTEM_PRINT "$echo_print10" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                    exit 0
                else
                    echo_print11=`SYSTEM_TIME;`"������Ĺؼ���<""$Key_Word"">�Ѿ��ҵ�"
                    echo `SYSTEM_PRINT "$echo_print11" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                fi
                Log_File=`date +%Y""%m""%d""%H""%M""%S`".log"                                         #�������ļ���
                #echo $Log_File
                h=`grep -n "$Key_Word" $Log_Path|awk -F ':' '{print $1}'|head -1`                                   #�ؼ��ֳ��ֵĵ�һ�е��к�
                echo_print12=`SYSTEM_TIME;`"�ؼ���<""$Key_Word"">���ֵĵ�һ��: $h"
                echo `SYSTEM_PRINT "$echo_print12" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                t=`grep -n "$Key_Word" $Log_Path|awk -F ':' '{print $1}'|tail -1`                                   #�ؼ��ֳ��ֵ����һ�е��к�
                echo_print13=`SYSTEM_TIME;`"�ؼ���<""$Key_Word""> ���ֵ����һ��: $t"
                echo `SYSTEM_PRINT "$echo_print13" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo "������Ҫ��ȡ�ĵ�һ�е��к�:"
                read Head_Number
                echo_print14=`SYSTEM_TIME;`"������ĵ�һ���к���: $Head_Number"
                echo `SYSTEM_PRINT "$echo_print14" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo "������Ҫ��ȡ�����һ�е��к�:"
                read End_Number
                echo_print15=`SYSTEM_TIME;`"����������һ���к���: $End_Number"
                echo `SYSTEM_PRINT "$echo_print15" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo_print16=`SYSTEM_TIME;`"���ڽ�ȡ��־�����ĵȴ�..."
                echo `SYSTEM_PRINT "$echo_print16" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                sed -n "$Head_Number,$End_Number p" $Log_Path>$Sed_Log_Path                                #����������кŽ�ȡ��־
                echo_print17=`SYSTEM_TIME;`"����ȡ����־�����: $Sed_Log_Path"
                echo `SYSTEM_PRINT "$echo_print17" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                exit 0
            else
                echo_print18=`SYSTEM_TIME;`"��ѡ������кŲ���ȷ,������ѡ����־·��:"
                echo `SYSTEM_PRINT "$echo_print18" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
                continue
            fi
        fi
      done
       
       
  elif [ $Log_Way = "2" ]                                                                                       #ѡ��2ʱʹ��ʱ���ȡ��־
  then
      echo_print19=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ����ʹ��ʱ��ν�ȡ��־"
      echo `SYSTEM_PRINT "$echo_print19" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      
      

echo "##################################################################################################################################"
cat $Find_Log_Config
echo "<0> ������һ��Ŀ¼"
echo "##################################################################################################################################"

        
      while true                                                                                                #������Ϊ���ʱ��ִ�����²���
      do
        echo_print20=`SYSTEM_TIME;`"����ѡ����־·�������кŻ򷵻���һ��Ŀ¼:"
        echo `SYSTEM_PRINT "$echo_print20" "3";`
        read Log_Number
        
        if [ $Log_Number = "0" ]                                                                                         #ѡ��0��ʱ���˻��ϲ�Ŀ¼
        then
            echo_print21=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ���˷�����һ��Ŀ¼"
            echo `SYSTEM_PRINT "$echo_print21" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
            exit 0
        else        
               
            Check_Number=`grep "<$Log_Number>" $Find_Log_Config|wc -l`                             #У��ѡ�����־·��������
            if [ $Check_Number = "1" ]                                                                              #��ѡ�����־·��������1��ʱ��,ִ�����²���
            then
                Log_Path=`grep "<$Log_Number>" $Find_Log_Config|awk '{print $2}'`                  #��־��·��
                echo_print22=`SYSTEM_TIME;`"��ѡ�����־·����:$Log_Path"
                echo `SYSTEM_PRINT "$echo_print22" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                Now_Time=`date +%Y-%m-%d" "%H:%M`                                                                   #��ǰ��ʱ��
                echo_print24=`SYSTEM_TIME;`"��ǰ��ʱ����:$Now_Time"
                echo `SYSTEM_PRINT "$echo_print24" "3";`
                echo_print25=`SYSTEM_TIME;`"��������־��ʼ��ʱ��:"
                echo `SYSTEM_PRINT "$echo_print25" "3";`
                read Start_Time
                echo_print26=`SYSTEM_TIME;`"���������־��ʼʱ����:$Start_Time"
                echo `SYSTEM_PRINT "$echo_print26" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
                Grep_Start=`grep "<<<$Start_Time" $Log_Path|wc -l`                                                  #У�鿪ʼʱ������־�е�����    
                if [ $Grep_Start = "0" ]                                                                            #�����0��ʾδ�ҵ���ʱ���
                then
                    echo_print27=`SYSTEM_TIME;`"������Ŀ�ʼʱ��δ�ҵ�:"
                    echo `SYSTEM_PRINT "$echo_print27" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                    exit 0
                fi
                echo_print28=`SYSTEM_TIME;`"��������־������ʱ��:"
                echo `SYSTEM_PRINT "$echo_print28" "3";`
                read End_Time
                echo_print29=`SYSTEM_TIME;`"���������־����ʱ����:$End_Time"
                echo `SYSTEM_PRINT "$echo_print29" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
                Grep_End=`grep "<<<$End_Time" $Log_Path|wc -l`                                                       #У�������ʱ������־�е�����
                if [ $Grep_End = "0" ]                                                                               #�����0��ʾδ�ҵ���ʱ���
                then
                    echo_print30=`SYSTEM_TIME;`"������Ľ���ʱ��δ�ҵ�:"
                    echo `SYSTEM_PRINT "$echo_print30" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                    exit 0
                fi 
                Time_Head=`grep -n "<<<$Start_Time" $Log_Path|awk -F ':' '{print $1}'`                               #��ʼʱ����ֵ��к�
                Time_End=`grep -n "<<<$End_Time" $Log_Path|awk -F ':' '{print $1}'`                                  #����ʱ����ֵ��к�

                Log_File=`date +%Y""%m""%d""%H""%M""%S`".log"                                          #�������ļ���
                echo_print31=`SYSTEM_TIME;`"���ڽ�ȡ��־�����ĵȴ�..."
                echo `SYSTEM_PRINT "$echo_print31" "3";`
                sed -n "$Time_Head,$Time_End p" $Log_Path>$Sed_Log_Path                                     #����ʱ����ֵ��кŽ�ȡ��־
                echo_print32=`SYSTEM_TIME;`"����ȡ����־������: $Sed_Log_Path"
                echo `SYSTEM_PRINT "$echo_print32" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                exit 0
            else
                echo_print33=`SYSTEM_TIME;`"��ѡ������кŲ���ȷ,������ѡ����־·��"
                echo `SYSTEM_PRINT "$echo_print33" "3";`
                continue
            fi
        fi
      done

  else
      echo "��ѡ������кŲ���ȷ,������ѡ��"
      continue

      
      
  fi
done
