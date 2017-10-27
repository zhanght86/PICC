#!/usr/bin/env python
#coding:utf-8
#create for get zabbix history data and send to customer
#Picc日报：统计每个系统的cpu、memory、disk的平均使用率及高峰期使用率
#jvm初始化的时候分配了固定的内存，所以内存变化不会很大不用统计高峰期使用率
#disk使用超过80%会及时清理，所以也不用统计内存的高峰期使用率

import os
import time
from zabbix_client import ZabbixServerProxy
from operator import itemgetter
from smtp_mail import sendMail
#转换为unix time
def toUnixTime(t):
    s = time.mktime(time.strptime(t, '%Y-%m-%d %H:%M:%S'))
    return int(s)

#转换为format time
def toDateTime(t):
    t = time.localtime(t)
    s = time.strftime('%Y-%m-%d %H:%M:%S',t)
    return s 

#获取Item历史数据
def getItemHistory(itemid,ftime,ttime,invl_num):
    #h = s.history.get(itemids=26898,time_from=1508720400,time_till=1508752800,output="extend",history=0,sortfield="clock",sortorder="ASC",limit=0)
    h = s.history.get(itemids=itemid,time_from=ftime,time_till=ttime,output="extend",history=0,sortfield="clock",sortorder="ASC",limit=0)
    h_len = len(h)

    #求最大最小值（对list按value值从大到小排序）
    v = itemgetter('value')
    hv = sorted(h,key=v)            
    max_value = float(hv[-1]['value'])
    max_time = hv[-1]['clock']
    min_value = float(hv[0]['value'])
    min_time = hv[0]['clock']

    #求平均值（将value值放到list中求和）
    ivalue_list = [float(v(i)) for i in h]
    avg_value = sum(ivalue_list) / h_len
    #avg_value = "%0.2f" % avg_value

    #求高峰期均值（每invl_num个连续的value分为一组，取各组之间的最大值为高峰期均值）
    interval_list = [sum(ivalue_list[i:i+invl_num]) for i in range(0,h_len,invl_num)]
    high_max_value = max(interval_list)
    high_avg_value = high_max_value / invl_num
    #high_avg_value = "%02.f" % high_avg_value
    high_avg_time = h[interval_list.index(high_max_value) * invl_num]['clock']

    #返回一个list，分别是最大值（发生时间），最小值（发生时间），平均值，高峰期平均值（发生时间）
    return ["%0.2f" % max_value,max_time,"%0.2f" % min_value,min_time,"%0.2f" % avg_value,"%0.2f" % high_avg_value,high_avg_time]


if __name__ == "__main__":

    #zabbix API
    zabbix_url = "http://10.133.210.130/api_jsonrpc.php"
    user = "epicc"
    password = "epicc"
    
    #item name
    itemnames = {}
    cpuname = "Used_cpu_percentage"
    memname = "Used memory (percentage)"
    dskname = "Free disk space on $1 (percentage)"
    itemnames["cpu使用率"] = cpuname
    itemnames["mem使用率"] = memname
    itemnames["dsk空闲率"] = dskname
    
    #hostnames
    crmweb_hosts = ["10.133.210.128","10.133.210.129"]
    clubweb_hosts = ["10.133.210.13","10.133.210.14","10.133.210.15","10.133.210.16"]
    intfce_hosts = ["10.133.210.128","10.133.210.129","10.133.214.103","10.133.214.104","10.133.214.105"]
    hosts = list(set(crmweb_hosts + clubweb_hosts + intfce_hosts))

    #入参
    """
    str_ftime = sys.argv[1]
    str_ttime = sys.argv[2]
    invltimes = int(sys.argv[3])
    """
    
    str_ftime= "2017-10-23 09:00:00"
    str_ttime= "2017-10-23 18:00:00"
    ftime = toUnixTime(str_ftime)
    ttime = toUnixTime(str_ttime)
    invltimes = 10
    
      
    #zabbix 登陆接口
    s = ZabbixServerProxy(zabbix_url)
    s.user.login(user=user,password=password)
    

    #开始循环之前的准备
    #1，打开一个csv，将详细数据保存到里面去
    csv = "tmp/" + "sys_history_" + time.strftime('%Y%m%d_%H%M',time.localtime()) + ".csv"
    with open(csv,'w') as fcsv:

        print >> fcsv,"统计时间起始时间,统计结束时间"
        print >> fcsv,"%s,%s" % (str_ftime,str_ttime)
        print >> fcsv,"系统名称,主机,监控项,最大值,最大值发生时间,最小值,最小值发生时间,平均值,高峰期均值,高峰期均值时间"
    
    
        #2，初始化一个字典，用于保存数据
        history = {}
    
        #循环start -----------
        for h in hosts:
            item_datas = {}
            for m,n in itemnames.items():
                #s.item.get(output="extend",host="10.133.210.14",search={'name':"Used_cpu_percentage"})
                item = s.item.get(output=["itemid","delay"],host=h,search={'name':n})[0]
                itemid = item['itemid']
                delay = item['delay']
                invl_num = (invltimes * 60) / 30
                idata = getItemHistory(itemid,ftime,ttime,invl_num)
                item_datas[n] = idata
    
                #向csv中写入详细数据start -----------
                if h in crmweb_hosts:
                    sys = "内管系统"
                elif h in clubweb_hosts:
                    sys = "客户系统"
                else:
                    sys = "公共接口"
    
                maxtime = toDateTime(float(idata[1]))
                mintime = toDateTime(float(idata[3]))
                avgtime = toDateTime(float(idata[6]))
    
                print  >> fcsv, "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % (sys,h,m,idata[0],maxtime,idata[2],mintime,idata[4],idata[5],avgtime)
                #向csv中写入详细数据end -----------
    
            print >> fcsv,"\n"
    
            #保存的数据格式为：{host1:{cpu:[value],mem:[value],dsk:[value]},host1:{cpu:[value],mem:[value],dsk:[value]}}
            history[h] = item_datas
    #print history
    s.user.logout()
    #循环end -----------
    
    #提取邮件数据start -----------
    mail_html = "<p>您好，本次统计数据如下：</p>\n"
    mail_html += "<p>统计开始时间：%s</p>\n" % str_ftime
    mail_html += "<p>统计结束时间：%s</p>\n" % str_ttime
    mail_html += "<br /><br />\n"
    mail_html += "<table border=\"1\">\n"
    mail_html += "<tr><th>系统名称</th><th>监控项</th><th>最大值（百分比）</th><th>最小值（百分比）</th><th>平均值（百分比）</th><th>高峰期均值(%s分钟)</th></tr>\n" % invltimes

    sys_hosts = {}
    sys_hosts['内管系统'] = crmweb_hosts
    sys_hosts['客户系统'] = clubweb_hosts
    sys_hosts['公共接口'] = intfce_hosts

    for hosts,hosts_list in sys_hosts.items():

        rowspan = 0 
        for m,n in itemnames.items():
            max_n = []
            min_n = []
            avg_n = []
            high_n = []

            for h in hosts_list:
                max_n.append(history[h][n][0])
                min_n.append(history[h][n][2])
                avg_n.append(float(history[h][n][4]))
                high_n.append(history[h][n][5])


            max_n = max(max_n)
            min_n = min(min_n)
            avg_n = sum(avg_n) / len(avg_n)
            high_n = max(high_n)

            if rowspan == 0:
                mail_html += "<tr><th rowspan=\"%s\">%s</th><th>%s</th><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n" % (len(itemnames),hosts,m,max_n,min_n,avg_n,high_n)
                rowspan = 1
            else:
                mail_html += "<tr><th>%s</th><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n" % (m,max_n,min_n,avg_n,high_n)

    mail_html += "</table>\n"
    #print mail_html
    #提取邮件数据end -----------
    #发送邮件start -----------
    subject = "Zabbix Datas"
    mail_to = "xiangshijian@sinosoft.com.cn"
    mail_cc = "club@sinosoft.com.cn"

    sendMail(subject,mail_to,mail_cc,mail_html,"html",csv)
    print "邮件发送成功！"
    #发邮件 over -----------

