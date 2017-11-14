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



echo_print1=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了使用自定义方式截取日志"
echo `SYSTEM_PRINT "$echo_print1" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog


while true 
do
  echo_print2=`SYSTEM_TIME;`"您要查找的日志路径是（例如:/log/ecardomain/nohup.out)"
  echo `SYSTEM_PRINT "$echo_print2" "3";`
  read Log_Path
  echo_print3=`SYSTEM_TIME;`"您要查找的日志路径是:$Log_Path"
  echo `SYSTEM_PRINT "$echo_print3" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog

  if [ -f $Log_Path ]
  then
      echo_print6=`SYSTEM_TIME;`"请输入要截取的关键字:"
      echo `SYSTEM_PRINT "$echo_print6" "3";`
      read keyword
      echo_print7=`SYSTEM_TIME;`"您要截取的关键字是$keyword"
      echo `SYSTEM_PRINT "$echo_print7" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      grepnumber=`grep -c "$keyword" $Log_Path`
      if [ $grepnumber = "0" ];
      then
          echo_print8=`SYSTEM_TIME;`"您输入的关键字未找到"
          echo `SYSTEM_PRINT "$echo_print8" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
          exit 0
      else
          echo_print9=`SYSTEM_TIME;`"您输入的关键字已经找到"
          echo `SYSTEM_PRINT "$echo_print9" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      fi
      logfile=`date +%Y""%m""%d""%H""%M""%S`".log"
      h=`grep -n "$keyword" $Log_Path|awk -F ':' '{print $1}'|head -1`
      echo_print10=`SYSTEM_TIME;`"关键字出现的第一行: $h"
      echo `SYSTEM_PRINT "$echo_print10" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      t=`grep -n "$keyword" $Log_Path|awk -F ':' '{print $1}'|tail -1`
      echo_print11=`SYSTEM_TIME;`"关键字出现的最后一行: $t"
      echo `SYSTEM_PRINT "$echo_print11" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      echo_print12=`SYSTEM_TIME;`"请输入要截取的第一行的行号:"
      echo `SYSTEM_PRINT "$echo_print12" "3";`
      read a
      echo_print13=`SYSTEM_TIME;`"请输入要截取的最后一行的行号:"
      echo `SYSTEM_PRINT "$echo_print13" "3";`
      read b
      echo "正在截取日志请耐心等待"
      echo_print14=`SYSTEM_TIME;`"您截取的第一行是$a 最后一行是$b 日志正在截取..."
      echo `SYSTEM_PRINT "$echo_print14" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      sed -n "$a,$b p" $Log_Path>/log/tmp_log/$logfile
      echo_print15=`SYSTEM_TIME;`"您截取的日志存放在: /log/tmp_log/$logfile"
      echo `SYSTEM_PRINT "$echo_print15" "3";`
      exit 0
  else
      echo_print16=`SYSTEM_TIME;`"您输入的日志路径有误"
      echo `SYSTEM_PRINT "$echo_print16" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      continue
  fi
done
