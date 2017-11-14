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

echo `SYSTEM_PRINT "**************************************<start_Linux_mainmenu.sh>**************************************" "1" ;`

export Linux_MainPath="$MainPath/Linux"                                                                    #--定义Linux运维小工具主路径
export LINUX_File_Tmp="$MainPath/Linux/shs/tmp"
echo `SYSTEM_PRINT "Linux_MainPath: $Linux_MainPath" "1" ;`
. $Linux_MainPath/Linux_init_function.sh                                                                        #--调用所需函数

Find_Log_Config=$LINUX_File_Tmp/nowlog.txt
Log_File=`date +%Y""%m""%d""%H""%M""%S`".log"                                          #保存后的文件名
Sed_Log_Path=/log/tmp_log/$Log_File

cat << FORE
##################################################################################################################################
<1> 使用关键字截取日志
<2> 使用时间段截取日志
<0> 返回上一层目录
##################################################################################################################################
FORE
while true 
do

echo_print1=`SYSTEM_TIME;`"请您选择截取日志的方式或返回上一层目录:"
echo `SYSTEM_PRINT "$echo_print1" "3";`
read Log_Way

  if [ $Log_Way = "0" ]                                                                                         #选择0的时候退回上层目录
  then
      echo_print2=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了返回上一层目录"
      echo `SYSTEM_PRINT "$echo_print2" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      exit 0

  elif [ $Log_Way = "1" ]                                                                                       #选择1的时候使用关键字截取日志
  then
      echo_print3=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了使用关键字截取日志"
      echo `SYSTEM_PRINT "$echo_print3" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      
      
      
    
echo "##################################################################################################################################"
cat $Find_Log_Config
echo "<0> 返回上一层目录"
echo "##################################################################################################################################"

      while true                                                                                                #当条件为真的时候执行以下操作
      do 
        echo_print4=`SYSTEM_TIME;`"请您选择日志路径的序列号或返回上一层目录:"
        echo `SYSTEM_PRINT "$echo_print4" "3";`
        read Log_Number

        if [ $Log_Number = "0" ]                                                                                         #选择0的时候退回上层目录
        then
            echo_print5=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了返回上一层目录"
            echo `SYSTEM_PRINT "$echo_print5" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
            exit 0
        else

    
            Check_Number=`grep -c "<$Log_Number>" $Find_Log_Config`                           #校验选择的日志路径的行数

            if [ $Check_Number = "1" ]                                                                              #当选择的日志路径行数是1的时候,执行以下操作
            then
                Log_Path=`grep "<$Log_Number>" $Find_Log_Config|awk '{print $2}'`                  #日志的路径
                echo_print6=`SYSTEM_TIME;`"您选择的日志路径是:$Log_Path"
                echo `SYSTEM_PRINT "$echo_print6" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo_print8=`SYSTEM_TIME;`"请输入要截取的关键字:"
                echo `SYSTEM_PRINT "$echo_print8" "3";`
                read Key_Word
                echo_print9=`SYSTEM_TIME;`"您要截取的关键字是:<$Key_Word>"
                echo `SYSTEM_PRINT "$echo_print9" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                Grep_Number=`grep -n "$Key_Word" $Log_Path|wc -l`                                                   #统计查到的关键字行数
                #echo $Grep_Number
                if [ $Grep_Number = "0" ]                                                                           #当关键字的行数为0时，提示未找到
                then
                    echo_print10=`SYSTEM_TIME;`"您输入的关键字<""$Key_Word"">未找到"
                    echo `SYSTEM_PRINT "$echo_print10" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                    exit 0
                else
                    echo_print11=`SYSTEM_TIME;`"您输入的关键字<""$Key_Word"">已经找到"
                    echo `SYSTEM_PRINT "$echo_print11" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                fi
                Log_File=`date +%Y""%m""%d""%H""%M""%S`".log"                                         #保存后的文件名
                #echo $Log_File
                h=`grep -n "$Key_Word" $Log_Path|awk -F ':' '{print $1}'|head -1`                                   #关键字出现的第一行的行号
                echo_print12=`SYSTEM_TIME;`"关键字<""$Key_Word"">出现的第一行: $h"
                echo `SYSTEM_PRINT "$echo_print12" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                t=`grep -n "$Key_Word" $Log_Path|awk -F ':' '{print $1}'|tail -1`                                   #关键字出现的最后一行的行号
                echo_print13=`SYSTEM_TIME;`"关键字<""$Key_Word""> 出现的最后一行: $t"
                echo `SYSTEM_PRINT "$echo_print13" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo "请输入要截取的第一行的行号:"
                read Head_Number
                echo_print14=`SYSTEM_TIME;`"您输入的第一行行号是: $Head_Number"
                echo `SYSTEM_PRINT "$echo_print14" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo "请输入要截取的最后一行的行号:"
                read End_Number
                echo_print15=`SYSTEM_TIME;`"您输入的最后一行行号是: $End_Number"
                echo `SYSTEM_PRINT "$echo_print15" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                echo_print16=`SYSTEM_TIME;`"正在截取日志请耐心等待..."
                echo `SYSTEM_PRINT "$echo_print16" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                sed -n "$Head_Number,$End_Number p" $Log_Path>$Sed_Log_Path                                #根据输入的行号截取日志
                echo_print17=`SYSTEM_TIME;`"您截取的日志存放在: $Sed_Log_Path"
                echo `SYSTEM_PRINT "$echo_print17" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                exit 0
            else
                echo_print18=`SYSTEM_TIME;`"您选择的序列号不正确,请重新选择日志路径:"
                echo `SYSTEM_PRINT "$echo_print18" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
                continue
            fi
        fi
      done
       
       
  elif [ $Log_Way = "2" ]                                                                                       #选择2时使用时间截取日志
  then
      echo_print19=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了使用时间段截取日志"
      echo `SYSTEM_PRINT "$echo_print19" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      
      

echo "##################################################################################################################################"
cat $Find_Log_Config
echo "<0> 返回上一层目录"
echo "##################################################################################################################################"

        
      while true                                                                                                #当条件为真的时候执行以下操作
      do
        echo_print20=`SYSTEM_TIME;`"请您选择日志路径的序列号或返回上一层目录:"
        echo `SYSTEM_PRINT "$echo_print20" "3";`
        read Log_Number
        
        if [ $Log_Number = "0" ]                                                                                         #选择0的时候退回上层目录
        then
            echo_print21=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了返回上一层目录"
            echo `SYSTEM_PRINT "$echo_print21" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
            exit 0
        else        
               
            Check_Number=`grep "<$Log_Number>" $Find_Log_Config|wc -l`                             #校验选择的日志路径的行数
            if [ $Check_Number = "1" ]                                                                              #当选择的日志路径行数是1的时候,执行以下操作
            then
                Log_Path=`grep "<$Log_Number>" $Find_Log_Config|awk '{print $2}'`                  #日志的路径
                echo_print22=`SYSTEM_TIME;`"您选择的日志路径是:$Log_Path"
                echo `SYSTEM_PRINT "$echo_print22" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                Now_Time=`date +%Y-%m-%d" "%H:%M`                                                                   #当前的时间
                echo_print24=`SYSTEM_TIME;`"当前的时间是:$Now_Time"
                echo `SYSTEM_PRINT "$echo_print24" "3";`
                echo_print25=`SYSTEM_TIME;`"请输入日志开始的时间:"
                echo `SYSTEM_PRINT "$echo_print25" "3";`
                read Start_Time
                echo_print26=`SYSTEM_TIME;`"您输入的日志开始时间是:$Start_Time"
                echo `SYSTEM_PRINT "$echo_print26" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
                Grep_Start=`grep "<<<$Start_Time" $Log_Path|wc -l`                                                  #校验开始时间在日志中的行数    
                if [ $Grep_Start = "0" ]                                                                            #如果是0提示未找到该时间点
                then
                    echo_print27=`SYSTEM_TIME;`"您输入的开始时间未找到:"
                    echo `SYSTEM_PRINT "$echo_print27" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                    exit 0
                fi
                echo_print28=`SYSTEM_TIME;`"请输入日志结束的时间:"
                echo `SYSTEM_PRINT "$echo_print28" "3";`
                read End_Time
                echo_print29=`SYSTEM_TIME;`"您输入的日志结束时间是:$End_Time"
                echo `SYSTEM_PRINT "$echo_print29" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
                Grep_End=`grep "<<<$End_Time" $Log_Path|wc -l`                                                       #校验结束的时间在日志中的行数
                if [ $Grep_End = "0" ]                                                                               #如果是0提示未找到该时间点
                then
                    echo_print30=`SYSTEM_TIME;`"您输入的结束时间未找到:"
                    echo `SYSTEM_PRINT "$echo_print30" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                    exit 0
                fi 
                Time_Head=`grep -n "<<<$Start_Time" $Log_Path|awk -F ':' '{print $1}'`                               #开始时间出现的行号
                Time_End=`grep -n "<<<$End_Time" $Log_Path|awk -F ':' '{print $1}'`                                  #结束时间出现的行号

                Log_File=`date +%Y""%m""%d""%H""%M""%S`".log"                                          #保存后的文件名
                echo_print31=`SYSTEM_TIME;`"正在截取日志请耐心等待..."
                echo `SYSTEM_PRINT "$echo_print31" "3";`
                sed -n "$Time_Head,$Time_End p" $Log_Path>$Sed_Log_Path                                     #根据时间出现的行号截取日志
                echo_print32=`SYSTEM_TIME;`"您截取的日志保存在: $Sed_Log_Path"
                echo `SYSTEM_PRINT "$echo_print32" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                exit 0
            else
                echo_print33=`SYSTEM_TIME;`"您选择的序列号不正确,请重新选择日志路径"
                echo `SYSTEM_PRINT "$echo_print33" "3";`
                continue
            fi
        fi
      done

  else
      echo "您选择的序列号不正确,请重新选择"
      continue

      
      
  fi
done
