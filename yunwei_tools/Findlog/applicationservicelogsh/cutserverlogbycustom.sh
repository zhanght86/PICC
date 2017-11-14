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



echo_print1=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ����ʹ���Զ��巽ʽ��ȡ��־"
echo `SYSTEM_PRINT "$echo_print1" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog


while true 
do
  echo_print2=`SYSTEM_TIME;`"��Ҫ���ҵ���־·���ǣ�����:/log/ecardomain/nohup.out)"
  echo `SYSTEM_PRINT "$echo_print2" "3";`
  read Log_Path
  echo_print3=`SYSTEM_TIME;`"��Ҫ���ҵ���־·����:$Log_Path"
  echo `SYSTEM_PRINT "$echo_print3" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog

  if [ -f $Log_Path ]
  then
      echo_print6=`SYSTEM_TIME;`"������Ҫ��ȡ�Ĺؼ���:"
      echo `SYSTEM_PRINT "$echo_print6" "3";`
      read keyword
      echo_print7=`SYSTEM_TIME;`"��Ҫ��ȡ�Ĺؼ�����$keyword"
      echo `SYSTEM_PRINT "$echo_print7" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      grepnumber=`grep -c "$keyword" $Log_Path`
      if [ $grepnumber = "0" ];
      then
          echo_print8=`SYSTEM_TIME;`"������Ĺؼ���δ�ҵ�"
          echo `SYSTEM_PRINT "$echo_print8" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
          exit 0
      else
          echo_print9=`SYSTEM_TIME;`"������Ĺؼ����Ѿ��ҵ�"
          echo `SYSTEM_PRINT "$echo_print9" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      fi
      logfile=`date +%Y""%m""%d""%H""%M""%S`".log"
      h=`grep -n "$keyword" $Log_Path|awk -F ':' '{print $1}'|head -1`
      echo_print10=`SYSTEM_TIME;`"�ؼ��ֳ��ֵĵ�һ��: $h"
      echo `SYSTEM_PRINT "$echo_print10" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      t=`grep -n "$keyword" $Log_Path|awk -F ':' '{print $1}'|tail -1`
      echo_print11=`SYSTEM_TIME;`"�ؼ��ֳ��ֵ����һ��: $t"
      echo `SYSTEM_PRINT "$echo_print11" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      echo_print12=`SYSTEM_TIME;`"������Ҫ��ȡ�ĵ�һ�е��к�:"
      echo `SYSTEM_PRINT "$echo_print12" "3";`
      read a
      echo_print13=`SYSTEM_TIME;`"������Ҫ��ȡ�����һ�е��к�:"
      echo `SYSTEM_PRINT "$echo_print13" "3";`
      read b
      echo "���ڽ�ȡ��־�����ĵȴ�"
      echo_print14=`SYSTEM_TIME;`"����ȡ�ĵ�һ����$a ���һ����$b ��־���ڽ�ȡ..."
      echo `SYSTEM_PRINT "$echo_print14" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      sed -n "$a,$b p" $Log_Path>/log/tmp_log/$logfile
      echo_print15=`SYSTEM_TIME;`"����ȡ����־�����: /log/tmp_log/$logfile"
      echo `SYSTEM_PRINT "$echo_print15" "3";`
      exit 0
  else
      echo_print16=`SYSTEM_TIME;`"���������־·������"
      echo `SYSTEM_PRINT "$echo_print16" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      continue
  fi
done
