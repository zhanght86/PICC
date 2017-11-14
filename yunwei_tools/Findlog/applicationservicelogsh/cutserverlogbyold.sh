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
      
      
      while read  i ;do
        echo $i
      done <$LINUX_File_Tmp/domainname.txt  
      
      echo_print34=`SYSTEM_TIME;`"��ѡ��Ҫ��ȡ��domain����"
      echo `SYSTEM_PRINT "$echo_print34" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      read Domain_Num
          
      Domain_Name=`grep "<$Domain_Num>" $LINUX_File_Tmp/domainname.txt|awk '{print $2}'`
      
      echo_print35=`SYSTEM_TIME;`"��ѡ��Ҫ��ȡ��domain������$Domain_Name"
      echo `SYSTEM_PRINT "$echo_print35" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      d=0
     for i in `find /log/$Domain_Name/LOG_BAK -name \**out.gz`
     do 
       d=`expr $d + 1`
       echo "<$d> $i"
     done>$LINUX_File_Tmp/oldlog.txt
echo "##################################################################################################################################"
cat $LINUX_File_Tmp/oldlog.txt
cat << AAA
<0> ������һ��Ŀ¼
##################################################################################################################################
AAA

     while true 
     do 
     
       echo_print4=`SYSTEM_TIME;`"��ѡ����Ҫ��ѹ����־�򷵻���һ��Ŀ¼"
       echo `SYSTEM_PRINT "$echo_print4" "3";`
       read log_num
       if [ $log_num = "0" ]                                                                                         #ѡ��0��ʱ���˻��ϲ�Ŀ¼
       then
           echo_print5=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ���˷�����һ��Ŀ¼"
           echo `SYSTEM_PRINT "$echo_print5" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
           exit 0
       else
           check_log=`grep -c "<$log_num>" $LINUX_File_Tmp/oldlog.txt`
           if [ $check_log = "1" ];
           then
               log_name=`grep "<$log_num>" $LINUX_File_Tmp/oldlog.txt|awk '{print $2}'`
               echo_print6=`SYSTEM_TIME;`"��ѡ�����־·����:$log_name"
               echo `SYSTEM_PRINT "$echo_print6" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
               echo_print8=`SYSTEM_TIME;`"������Ҫ��ȡ�Ĺؼ���:"
               echo `SYSTEM_PRINT "$echo_print8" "3";`
               read keyword
               echo_print9=`SYSTEM_TIME;`"��Ҫ��ȡ�Ĺؼ�����:<$keyword>"
               echo `SYSTEM_PRINT "$echo_print9" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog        
               check_num=`gzip -dc $log_name|grep -n "$keyword"|wc -l`
               if [ $check_num = "0" ];
               then
                   echo_print10=`SYSTEM_TIME;`"������Ĺؼ���""<$keyword>""δ�ҵ�"
                   echo `SYSTEM_PRINT "$echo_print10" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                   exit 0
               else
                   echo_print11=`SYSTEM_TIME;`"������Ĺؼ���""<$keyword>""�Ѿ��ҵ�"
                   echo `SYSTEM_PRINT "$echo_print11" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               fi  
               log_file=`date +%Y""%m""%d""%H""%M""%S`".log"
               h=`gzip -dc $log_name|grep -n "$keyword"|awk -F ':' '{print $1}'|head -1`
               echo_print12=`SYSTEM_TIME;`"�ؼ���<$keyword>���ֵĵ�һ��: $h"
               echo `SYSTEM_PRINT "$echo_print12" "3";`
               t=`gzip -dc $log_name|grep -n "$keyword"|awk -F ':' '{print $1}'|tail -1`
               echo_print13=`SYSTEM_TIME;`"�ؼ���<$keyword>���ֵ����һ��: $t"
               echo `SYSTEM_PRINT "$echo_print13" "3";`
               echo_print14=`SYSTEM_TIME;`"������Ҫ��ȡ�ĵ�һ�е��к�:"
               echo `SYSTEM_PRINT "$echo_print14" "3";`
               read a
               echo_print15=`SYSTEM_TIME;`"�������ȡ��һ�е��к���:$a"
               echo `SYSTEM_PRINT "$echo_print15" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               echo_print16=`SYSTEM_TIME;`"������Ҫ��ȡ�����һ�е��к�:"
               echo `SYSTEM_PRINT "$echo_print16" "3";`
               read b
               echo_print17=`SYSTEM_TIME;`"�������ȡ���һ�е��к���:$b"
               echo `SYSTEM_PRINT "$echo_print17" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               echo "���ڽ�ȡ��־�����ĵȴ�"
               echo_print18=`SYSTEM_TIME;`"���ڽ�ȡ��־�����ĵȴ�..."
               echo `SYSTEM_PRINT "$echo_print18" "3";`
               gzip -dc $log_name|sed -n "$a,$b p">/log/tmp_log/$log_file
               echo "����ȡ����־�����: /log/tmp_log/$log_file" 
               echo_print19=`SYSTEM_TIME;`"����ȡ����־�����: /log/tmp_log/$log_file"
               echo `SYSTEM_PRINT "$echo_print19" "3";`  
               exit 0
           else 
               echo_print20=`SYSTEM_TIME;`"�������Ϊ�������кţ�����������"
               echo `SYSTEM_PRINT "$echo_print20" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               continue
           fi
       fi
     done

  elif [ $Log_Way = "2" ]                                                                                       #ѡ��2��ʱ��ʹ��ʱ��ν�ȡ��־
  then
      echo_print21=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ����ʹ��ʱ��ν�ȡ��־"
      echo `SYSTEM_PRINT "$echo_print21" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      
      
      while read  i ;do
        echo $i
      done <$LINUX_File_Tmp/domainname.txt  
      
      echo_print36=`SYSTEM_TIME;`"��ѡ��Ҫ��ȡ��domain����"
      echo `SYSTEM_PRINT "$echo_print36" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      read Domain_Num
           
      Domain_Name=`grep "<$Domain_Num>" $LINUX_File_Tmp/domainname.txt|awk '{print $2}'`
      echo_print37=`SYSTEM_TIME;`"��ѡ��Ҫ��ȡ��domain������$Domain_Name"
      echo `SYSTEM_PRINT "$echo_print37" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      d=0
      for i in `find /log/$Domain_Name/LOG_BAK -name \**out.gz`
      do 
        d=`expr $d + 1`
        echo "<$d> $i"
      done>$LINUX_File_Tmp/oldlog.txt
echo "##################################################################################################################################"
cat $LINUX_File_Tmp/oldlog.txt
cat << AAA
<0> ������һ��Ŀ¼
##################################################################################################################################
AAA

     while true 
     do
       echo_print22=`SYSTEM_TIME;`"��ѡ����Ҫ��ѹ����־�򷵻���һ��Ŀ¼"
       echo `SYSTEM_PRINT "$echo_print22" "3";`
       read log_num
       if [ $log_num = "0" ]                                                                                         #ѡ��0��ʱ���˻��ϲ�Ŀ¼
       then
           echo_print23=`SYSTEM_TIME;`"�𾴵��û�<""$User_Name"">����ѡ���˷�����һ��Ŀ¼"
           echo `SYSTEM_PRINT "$echo_print23" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
           exit 0
       else  
           check_log=`grep -c "<$log_num>" $LINUX_File_Tmp/oldlog.txt`
           if [ $check_log = "1" ];
           then
               logpath=`grep "<$log_num>" $LINUX_File_Tmp/oldlog.txt|awk '{print $2}'`
               echo_print24=`SYSTEM_TIME;`"��ѡ�����־·����:$logpath"
               echo `SYSTEM_PRINT "$echo_print24" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               time=`date +%Y-%m-%d" "%H:%M`
               echo_print26=`SYSTEM_TIME;`"��ǰ��ʱ����:$time"
               echo `SYSTEM_PRINT "$echo_print26" "3";`
               echo_print27=`SYSTEM_TIME;`"��������־��ʼ��ʱ��:"
               echo `SYSTEM_PRINT "$echo_print27" "3";`
               read starttime
               grepstart=`gzip -dc $logpath|grep "<<<$starttime"|wc -l`      
               if [ $grepstart = "0" ]
               then
                   echo_print28=`SYSTEM_TIME;`"������Ŀ�ʼʱ��δ�ҵ�"
                   echo `SYSTEM_PRINT "$echo_print28" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                   exit 0
               fi
             
              echo_print29=`SYSTEM_TIME;`"��������־������ʱ��:"
              echo `SYSTEM_PRINT "$echo_print29" "3";`
              read endtime
              grepend=`gzip -dc $logpath|grep "<<<$endtime"|wc -l`
              if [ $grepend = "0" ]
              then
                  echo_print30=`SYSTEM_TIME;`"������Ľ���ʱ��δ�ҵ�"
                  echo `SYSTEM_PRINT "$echo_print30" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                  exit 0
              fi 
             
               timehead=`gzip -dc $logpath|grep -n "<<<$starttime"|awk -F ':' '{print $1}'`
               timeend=`gzip -dc $logpath|grep -n "<<<$endtime"|awk -F ':' '{print $1}'`  
               logfile=`date +%Y""%m""%d""%H""%M""%S`".log"
               echo_print31=`SYSTEM_TIME;`"���ڽ�ȡ��־�����ĵȴ�"
               echo `SYSTEM_PRINT "$echo_print31" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               gzip -dc $logpath|sed -n "$timehead,$timeend p">/log/tmp_log/$logfile
               echo_print32=`SYSTEM_TIME;`"��ȡ����־������: /log/tmp_log/$logfile"
               echo `SYSTEM_PRINT "$echo_print32" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               exit 0      
                 
           else 
               echo_print33=`SYSTEM_TIME;`"�������Ϊ�������кţ�����������"
               echo `SYSTEM_PRINT "$echo_print33" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               continue
           fi
       fi
     done
     
  else
      echo "��ѡ������кŲ���ȷ,������ѡ��"
      continue
  fi
done
