#!/bin/bash
#for linux

echo -e "PID\t\tSwap\t\tProc_Name"
# �ó�/procĿ¼������������Ϊ����Ŀ¼�������������ֲ��ǽ��̣�������sys,net�ȴ�ŵ���������Ϣ��
for pid in `ls -l /proc | grep ^d | awk '{ print $9 }'| grep -v [^0-9]`
do
 # �ý����ͷ�swap�ķ���ֻ��һ�������������ý��̡����ߵ����Զ��ͷš�
 # ������̻��Զ��ͷţ���ô���ǾͲ���д�ű��������ˣ�����������Ϊ��û���Զ��ͷš�
 # ��������Ҫ�г�ռ��swap����Ҫ�����Ľ��̣�����init���������ϵͳ�����н��̵����Ƚ���
 # ����init������ζ������ϵͳ���������򲻿��Եģ����ԾͲ��ؼ�����ˣ������ϵͳ���Ӱ�졣
 if [ $pid -eq 1 ];then continue;fi # Do not check init process
 # �жϸĽ����Ƿ�ռ����swap
 grep -q "Swap" /proc/$pid/smaps 2>/dev/null
 if [ $? -eq 0 ];then # ���ռ����swap
 # ռ��swap���ܴ�С����λ��KB��
 swap=$(grep Swap /proc/$pid/smaps | gawk '{ sum+=$2;} END{ print sum }')
 # ������
 proc_name=$(ps aux | grep -w "$pid" | grep -v grep | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
 if [ $swap -gt 0 ];then # ���ռ����swap���������Ϣ
 echo -e "$pid\t${swap}\t$proc_name"
 fi
 fi
done | sort -k2 -n | gawk -F'\t' '{ 
# ��ռ��swap�Ĵ�С��������awkʵ�ֵ�λת����
# �磺��1024KBת����1M����1048576KBת����1G������߿ɶ��ԡ�
 pid[NR]=$1;
 size[NR]=$2;
 name[NR]=$3;
}
END{
 for(id=1;id<=length(pid);id++)
 {
     if(size[id]<1024)
           printf("%-10s\t%15sKB\t%s\n",pid[id],size[id],name[id]);
     else if(size[id]<1048576)
           printf("%-10s\t%15.2fMB\t%s\n",pid[id],size[id]/1024,name[id]);
     else
   printf("%-10s\t%15.2fGB\t%s\n",pid[id],size[id]/1048576,name[id]);
 }
}'



