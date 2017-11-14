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
      
      
      while read  i ;do
        echo $i
      done <$LINUX_File_Tmp/domainname.txt  
      
      echo_print34=`SYSTEM_TIME;`"请选择要截取的domain名称"
      echo `SYSTEM_PRINT "$echo_print34" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      read Domain_Num
          
      Domain_Name=`grep "<$Domain_Num>" $LINUX_File_Tmp/domainname.txt|awk '{print $2}'`
      
      echo_print35=`SYSTEM_TIME;`"您选择要截取的domain名称是$Domain_Name"
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
<0> 返回上一层目录
##################################################################################################################################
AAA

     while true 
     do 
     
       echo_print4=`SYSTEM_TIME;`"请选择需要的压缩日志或返回上一层目录"
       echo `SYSTEM_PRINT "$echo_print4" "3";`
       read log_num
       if [ $log_num = "0" ]                                                                                         #选择0的时候退回上层目录
       then
           echo_print5=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了返回上一层目录"
           echo `SYSTEM_PRINT "$echo_print5" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
           exit 0
       else
           check_log=`grep -c "<$log_num>" $LINUX_File_Tmp/oldlog.txt`
           if [ $check_log = "1" ];
           then
               log_name=`grep "<$log_num>" $LINUX_File_Tmp/oldlog.txt|awk '{print $2}'`
               echo_print6=`SYSTEM_TIME;`"您选择的日志路径是:$log_name"
               echo `SYSTEM_PRINT "$echo_print6" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog 
               echo_print8=`SYSTEM_TIME;`"请输入要截取的关键字:"
               echo `SYSTEM_PRINT "$echo_print8" "3";`
               read keyword
               echo_print9=`SYSTEM_TIME;`"您要截取的关键字是:<$keyword>"
               echo `SYSTEM_PRINT "$echo_print9" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog        
               check_num=`gzip -dc $log_name|grep -n "$keyword"|wc -l`
               if [ $check_num = "0" ];
               then
                   echo_print10=`SYSTEM_TIME;`"您输入的关键字""<$keyword>""未找到"
                   echo `SYSTEM_PRINT "$echo_print10" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                   exit 0
               else
                   echo_print11=`SYSTEM_TIME;`"您输入的关键字""<$keyword>""已经找到"
                   echo `SYSTEM_PRINT "$echo_print11" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               fi  
               log_file=`date +%Y""%m""%d""%H""%M""%S`".log"
               h=`gzip -dc $log_name|grep -n "$keyword"|awk -F ':' '{print $1}'|head -1`
               echo_print12=`SYSTEM_TIME;`"关键字<$keyword>出现的第一行: $h"
               echo `SYSTEM_PRINT "$echo_print12" "3";`
               t=`gzip -dc $log_name|grep -n "$keyword"|awk -F ':' '{print $1}'|tail -1`
               echo_print13=`SYSTEM_TIME;`"关键字<$keyword>出现的最后一行: $t"
               echo `SYSTEM_PRINT "$echo_print13" "3";`
               echo_print14=`SYSTEM_TIME;`"请输入要截取的第一行的行号:"
               echo `SYSTEM_PRINT "$echo_print14" "3";`
               read a
               echo_print15=`SYSTEM_TIME;`"您输入截取第一行的行号是:$a"
               echo `SYSTEM_PRINT "$echo_print15" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               echo_print16=`SYSTEM_TIME;`"请输入要截取的最后一行的行号:"
               echo `SYSTEM_PRINT "$echo_print16" "3";`
               read b
               echo_print17=`SYSTEM_TIME;`"您输入截取最后一行的行号是:$b"
               echo `SYSTEM_PRINT "$echo_print17" "1";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               echo "正在截取日志请耐心等待"
               echo_print18=`SYSTEM_TIME;`"正在截取日志请耐心等待..."
               echo `SYSTEM_PRINT "$echo_print18" "3";`
               gzip -dc $log_name|sed -n "$a,$b p">/log/tmp_log/$log_file
               echo "您截取的日志存放在: /log/tmp_log/$log_file" 
               echo_print19=`SYSTEM_TIME;`"您截取的日志存放在: /log/tmp_log/$log_file"
               echo `SYSTEM_PRINT "$echo_print19" "3";`  
               exit 0
           else 
               echo_print20=`SYSTEM_TIME;`"您输入的为错误序列号，请重新输入"
               echo `SYSTEM_PRINT "$echo_print20" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               continue
           fi
       fi
     done

  elif [ $Log_Way = "2" ]                                                                                       #选择2的时候使用时间段截取日志
  then
      echo_print21=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了使用时间段截取日志"
      echo `SYSTEM_PRINT "$echo_print21" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      
      
      while read  i ;do
        echo $i
      done <$LINUX_File_Tmp/domainname.txt  
      
      echo_print36=`SYSTEM_TIME;`"请选择要截取的domain名称"
      echo `SYSTEM_PRINT "$echo_print36" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
      read Domain_Num
           
      Domain_Name=`grep "<$Domain_Num>" $LINUX_File_Tmp/domainname.txt|awk '{print $2}'`
      echo_print37=`SYSTEM_TIME;`"您选择要截取的domain名称是$Domain_Name"
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
<0> 返回上一层目录
##################################################################################################################################
AAA

     while true 
     do
       echo_print22=`SYSTEM_TIME;`"请选择需要的压缩日志或返回上一层目录"
       echo `SYSTEM_PRINT "$echo_print22" "3";`
       read log_num
       if [ $log_num = "0" ]                                                                                         #选择0的时候退回上层目录
       then
           echo_print23=`SYSTEM_TIME;`"尊敬的用户<""$User_Name"">，您选择了返回上一层目录"
           echo `SYSTEM_PRINT "$echo_print23" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
           exit 0
       else  
           check_log=`grep -c "<$log_num>" $LINUX_File_Tmp/oldlog.txt`
           if [ $check_log = "1" ];
           then
               logpath=`grep "<$log_num>" $LINUX_File_Tmp/oldlog.txt|awk '{print $2}'`
               echo_print24=`SYSTEM_TIME;`"您选择的日志路径是:$logpath"
               echo `SYSTEM_PRINT "$echo_print24" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               time=`date +%Y-%m-%d" "%H:%M`
               echo_print26=`SYSTEM_TIME;`"当前的时间是:$time"
               echo `SYSTEM_PRINT "$echo_print26" "3";`
               echo_print27=`SYSTEM_TIME;`"请输入日志开始的时间:"
               echo `SYSTEM_PRINT "$echo_print27" "3";`
               read starttime
               grepstart=`gzip -dc $logpath|grep "<<<$starttime"|wc -l`      
               if [ $grepstart = "0" ]
               then
                   echo_print28=`SYSTEM_TIME;`"您输入的开始时间未找到"
                   echo `SYSTEM_PRINT "$echo_print28" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                   exit 0
               fi
             
              echo_print29=`SYSTEM_TIME;`"请输入日志结束的时间:"
              echo `SYSTEM_PRINT "$echo_print29" "3";`
              read endtime
              grepend=`gzip -dc $logpath|grep "<<<$endtime"|wc -l`
              if [ $grepend = "0" ]
              then
                  echo_print30=`SYSTEM_TIME;`"您输入的结束时间未找到"
                  echo `SYSTEM_PRINT "$echo_print30" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
                  exit 0
              fi 
             
               timehead=`gzip -dc $logpath|grep -n "<<<$starttime"|awk -F ':' '{print $1}'`
               timeend=`gzip -dc $logpath|grep -n "<<<$endtime"|awk -F ':' '{print $1}'`  
               logfile=`date +%Y""%m""%d""%H""%M""%S`".log"
               echo_print31=`SYSTEM_TIME;`"正在截取日志请耐心等待"
               echo `SYSTEM_PRINT "$echo_print31" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               gzip -dc $logpath|sed -n "$timehead,$timeend p">/log/tmp_log/$logfile
               echo_print32=`SYSTEM_TIME;`"截取的日志保存在: /log/tmp_log/$logfile"
               echo `SYSTEM_PRINT "$echo_print32" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               exit 0      
                 
           else 
               echo_print33=`SYSTEM_TIME;`"您输入的为错误序列号，请重新输入"
               echo `SYSTEM_PRINT "$echo_print33" "3";` |tee -a $YunweiToolsLogPath/$YunweiToolsSystemLog
               continue
           fi
       fi
     done
     
  else
      echo "您选择的序列号不正确,请重新选择"
      continue
  fi
done
