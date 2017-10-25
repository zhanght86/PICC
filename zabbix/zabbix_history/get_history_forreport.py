#!/usr/bin/env python
#coding:utf-8
#create for get zabbix history data and send to customer
#Picc日报：统计每个系统的cpu、memory、disk的平均使用率及高峰期使用率
#jvm初始化的时候分配了固定的内存，所以内存变化不会很大不用统计高峰期使用率
#disk使用超过80%会及时清理，所以也不用统计内存的高峰期使用率

import time
from zabbix_client import ZabbixServerProxy
from operator import itemgetter


def toUnixTime(t):
    s = time.mktime(time.strptime(t, '%Y-%m-%d %H:%M:%S'))
    return int(s)


zabbix_url = "http://10.133.210.130/api_jsonrpc.php"
user = "epicc"
password = "epicc"

s = ZabbixServerProxy(zabbix_url)
s.user.login(user=user,password=password)

hostname = ['10.133.210.128','10.133.210.129','10.133.210.13','10.133.210.14','10.133.210.15','10.133.210.16','10.133.210.128','10.133.210.129','10.133.214.103','10.133.214.104','10.133.214.105']
cpuname = "Used_cpu_percentage"
memname = "Used memory (percentage)"
dskname = "Free disk space on $1 (percentage)"

ftime= "2017-10-23 09:00:00"
ttime= "2017-10-23 18:00:00"
ftime = toUnixTime(ftime)
ttime = toUnixTime(ttime)
interval_time = 10 * 60
#根据间隔时间计算给定的时间范围内有多少个分组
interval_gnum = (ttime - ftime) / interval_time

def getItemHistorys(itemname):
    h_itemids = {}
    #zabbix item.get接口一次只能返回一个item对象，所以得循环hostname，获取hostname对应的itemid的字典
    for i in hostname:
        #h_itemids[i]=s.item.get(output="itemid",host=i,search={'name':cpuname})[0]['itemid']
        h_itemids[i]=s.item.get(output="itemid",host=i,search={'name':itemname})[0]['itemid']

    #初始化一个字典对象，用于存放提取item对应的历史数据
    history = {}
    for k,v in h_itemids.items():
        #history.get接口根据输入的起始和截止时间提取对应item的历史数据
        h = s.history.get(itemids=v,time_from=ftime,time_till=ttime,output="extend",history=0,sortfield="clock",sortorder="ASC",limit=0)
        #将所有的item value放入一个list中，以供求最大、最小及平均值
        ivalue_list = [ float(i['value']) for i in h]
        ivalue_len = len(ivalue_list)
        max_value = max(ivalue_list)
        min_value = min(ivalue_list)
        avg_value = sum(ivalue_list) / ivalue_len
        
        #根据list长度计算每个分组的长度，然后将list拆分，计算每个分组的大小，得出高峰期均值
        num = ivalue_len / interval_gnum
        interval_list = [sum(ivalue_list[i:i+num]) for i in range(0,ivalue_len,num)]
        high_max_value = max(interval_list) / num
        high_max_time = ftime + (interval_list.index(max(interval_list)) + 1) * interval_time
        #print type(max_value),type(min_value),type(avg_value),type(high_max_value)

        host_datas = [('%0.2f' % max_value),('%0.2f' % min_value),('%0.2f' % avg_value),('%0.2f' % high_max_value),high_max_time]
        #host_datas = [max_value,min_value,avg_value,high_max_value,high_max_time]
        history[k] = host_datas
    
    print history
getItemHistorys(cpuname)
getItemHistorys(memname)
getItemHistorys(dskname)
s.user.logout()

