#!/usr/bin/python
#coding:utf-8

from zabbix import zabbix

filename="Readme.txt"
f = open(filename)
c = f.readlines()
f.close()
z = zabbix()
z.login()

#添加主机
def createHost():
  for i in c:
    if i.startswith("#") or i.startswith(" "):
  		continue
    else:
      i = i.split(" - ")
      ip = i[0]
      hgroups = i[2]
      htemplates = i[3]
      gpid = z.getHostGroupID(hgroups)
      tpid = z.getTemplateID(htemplates)
      z.createHost(ip, gpid, tpid)

#添加Item
def createItem():
  for i in c:
    if i.startswith("#") or i.startswith(" "):
      continue
    else:
      i = i.split(" - ")
      ip = i[0]
      port = i[1]
      mport = i[4]
      app = i[5]
      z.createSnmpIntf(ip,mport)
      hostid = z.getHostID(ip)
      intfid = z.getInterfaceID(ip, mport)
#添加HoggingThreadCount
      iname = "HoggingThreadCount_" + port
      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.367.1.55.16")
      appid = z.getApplicationID("Weblogic,HoggingThreadCount", hostid)
      z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=oid,appid=appid)

#添加HttpConnectionsCount
      iname = "HttpConnectionsCount_" + port
      appid = z.getApplicationID("Weblogic,HttpConnectionsCount",hostid)
      oid = z.getHttpSnmpOid(ip,mport)
      print "HttpConnectionsCount OID为：" , oid
      z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=oid,appid=appid)

#添加OpenSessionsCurrentCount
      iname = "OpenSessionsCurrentCount_" + port 
      oid = z.getSessionSnmpOid(ip,mport,app)
      print "OpenSessionsCurrentCount OID为：" , oid
      appid = z.getApplicationID("Weblogic,OpenSessionsCurrentCount",hostid)
      z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=oid,appid=appid)

#添加JvmHeapFreePercent
      iname = "JvmHeapFreePercent_" + port
      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.340.1.52")
      print "JvmHeapFreePercent OID为：" , oid
      appid = z.getApplicationID("Weblogic,JvmHeapFreePercent",hostid)
      units="%"
      z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=oid,appid=appid,units=units)

#添加ServerRuntimeState
      iname = "ServerRuntimeState_" + port
      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.360.1.60")
      appid = z.getApplicationID("Weblogic,ServerRuntimeState",hostid)
      vtype = 1
      z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=oid,appid=appid,vtype=vtype)

#添加DBActiveConnectionCount      
      appid = z.getApplicationID("Weblogic,DBActiveConnectionCount",hostid)
      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.191.1.80")
      print "下面是DB snmp oid："
      print oid
      print type(oid)
      for k,v in oid.items():
        iname = k + "_DBActiveConnectionCount_" + port
        z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=v,appid=appid)

#添加DBLeakedConnectionCount      
      appid = z.getApplicationID("Weblogic,DBLeakedConnectionCount",hostid)
      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.191.1.25")
      for k,v in oid.items():
        iname = k + "_DBLeakedConnectionCount_" + port 
        z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=v,appid=appid)

#添加DBConnectionRuntimeState      
      appid = z.getApplicationID("Weblogic,DBConnectionRuntimeState",hostid)
      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.190.1.75")
      vtype = 1
      for k,v in oid.items():
        iname = k + "_DBConnectionRuntimeState_" + port
        z.createSnmpItem(hostid=hostid,intfid=intfid,iname=iname,oid=v,appid=appid,vtype=vtype)




def createTrigger():

  for i in c:
    if i.startswith("#") or i.startswith(" "):
      continue
    else:
      i = i.split(' - ')
      ip = i[0]
      port = i[1]
      mport = i[4]
#添加 Check_HoggingThreadCount_Trigger
      name = "Check_HoggingThreadCount_" + port
      expression = "{%s:HoggingThreadCount_%s.min(3m,0)}>15" % (ip,port)
      print expression
      priority = 2
      z.createSnmpTrigger(name,expression,priority)

#添加Check_HttpConnectionsCount_Trigger
      name = "Check_HttpConnectionsCount_" + port
      expression = "{%s:HttpConnectionsCount_%s.min(5m,0)}>100" % (ip,port)
      print expression
      priority = 2
      z.createSnmpTrigger(name,expression,priority)

#添加Check_ServerRuntimeState_Trigger
      name = "Check_ServerRuntimeState_" + port
      expression = "{%s:ServerRuntimeState_%s.str(RUNNING)}<>1" % (ip,port)
      print expression
      priority = 4
      z.createSnmpTrigger(name,expression,priority)

      oid = z.getSnmpOid(ip,mport,".1.3.6.1.4.1.140.625.190.1.75")
      for k in oid:
#添加Check_DBActiveConnectionCount_Trigger
        name = "Check_%s_DBActiveConnectionCount_" % k + port
        expression = "{%s:%s_DBActiveConnectionCount_%s.min(5m)}>15" % (ip,k,port)
        print expression
        priority = 2
        z.createSnmpTrigger(name,expression,priority)

#添加Check_DBLeakedConnectionCount_Trigger
        name = "Check_%s_DBLeakedConnectionCount_" % k + port
        expression = "{%s:%s_DBLeakedConnectionCount_%s.last()}<>0" % (ip,k,port)
        print expression
        priority = 4
        z.createSnmpTrigger(name,expression,priority)

#添加Check_DBConnectionRuntimeState_Trigger
        name = "Check_%s_DBConnectionRuntimeState_" % k + port
        expression = "{%s:%s_DBConnectionRuntimeState_%s.str(Running)}<>1" % (ip,k,port)
        print expression
        priority = 4
        z.createSnmpTrigger(name,expression,priority)


if __name__ == "__main__":
#执行添加主机 or Item or Trigger函数，不需要使用的函数请注释掉
  createHost()
  createItem() 
  createTrigger()
