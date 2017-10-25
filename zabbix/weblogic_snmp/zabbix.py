#!/usr/bin/env python
#coding:utf-8

import requests
import json
import commands

class zabbix(object):
#api地址
  url = "http://10.133.210.130/api_jsonrpc.php"
  headers = {'Content-Type': 'application/json-rpc'}

#获取登陆验证码
  def login(self,username='epicc',password='epicc'):
    data = {
      "jsonrpc": "2.0",
      "method": "user.login",
      "params": {
        "user": username,
        "password": password
        },
      "id": 1,
      "auth": None,
      }
    rsp = requests.post(self.url, headers = self.headers, data = json.dumps(data))
    self.authid = rsp.json()['result']
    print u"Zabbix 登陆认证码：" + self.authid

#Post数据   
  def postData(self,data):
    postdata = json.dumps(data)
    rsp = requests.post(self.url, headers=self.headers, data=postdata)
    if rsp.status_code != 200:
      print "调用接口失败：" + rsp.status_code
    else:
      print u"Zabbix接口返回报文：" + rsp.text
      return rsp.text


#添加Host
  def createHost(self,ip,groups,templates,port=10050,enable=0):
    data = {
      "jsonrpc": "2.0",
      "method": "host.create",
      "params": {
          "host": ip,
          "status": enable,
          "interfaces": [
              {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": ip,
                "dns": "",
                "port": port
              },
              {
                "type": 2,
                "main": 1,
                "useip": 1,
                "ip": ip,
                "dns": "",
                "port": 17000
              }
          ],
          "groups": groups,
          "templates": templates,
          "inventory_mode": 1, 
          },
      "auth": self.authid,
      "id": 1
      } 
    print "添加监控主机报文："  
    print data
    self.postData(data)

#添加Host Interface
  def createSnmpIntf(self,ip,mport):
    hostid = self.getHostID(ip)
    data = {
      "jsonrpc": "2.0",
      "method": "hostinterface.create",
      "params": {
        "hostid": hostid,
        "dns": "",
        "ip": ip,
        "port": mport,
        "main": 0,       
        "type": 2,
        "useip": 1
      },
      "auth": self.authid,
      "id": 1
    }
    print "添加SNMP Host Interface报文："
    print data
    self.postData(data)

#添加snmp Items 
  def createSnmpItem(self,hostid,intfid,iname,oid,appid,mtype=1,vtype=3,dtype=0,units="",enable=0,delay=30,hst=90,trends=1000):
    data = {
      "jsonrpc": "2.0",
      "method": "item.create",
      "params": {
        "status": enable,
        "hostid": hostid,
        "name": iname,
        "key_": iname,
        "type": mtype,
        "interfaceid": intfid,
        "snmp_oid": oid,
        "value_type": vtype,
        "data_type": dtype,
        "applications": appid,
        "delay": delay,
        "history": hst,
        "trends": trends,
        "units": units,
        "snmp_community": "public"
        },
      "id": 1,
      "auth": self.authid,
    }
    print "添加Snmp 监控项报文："  
    print data
    self.postData(data)

#添加trigger
  def createSnmpTrigger(self,name,expressions,priority,enable=0):
    data ={
        "jsonrpc": "2.0",
        "method": "trigger.create",
        "params": {
            "description": name,
            "expression": expressions,
            "status": enable,
            "priority": priority,
        },
        "auth": self.authid,
        "id": 1
      }
    print "添加Trigger报文："  
    print data
    self.postData(data)

#获取templateid
  def getTemplateID(self,tpname):
    tpname = tpname.split(',')
    data = {
        "jsonrpc": "2.0",
        "method": "template.get",
        "params": {
            "output": "templateid",
            "filter": {
                "host": tpname
            }
        },
        "auth": self.authid,
        "id": 1
    }
    print "获取TemplateID报文："
    print data
    templates = self.postData(data)
    templates = eval(templates)
    tpid = templates['result']
#    tpid = []
#    for i in templates['result']:
#      tpid.append(i['templateid'])
    return tpid

#获取groupid
  def getHostGroupID(self,gpname):
    gpname = gpname.split(',')
    data = {
        "jsonrpc": "2.0",
        "method": "hostgroup.get",
        "params": {
            "output": "groupid",
            "filter": {
                "name": gpname
            }
        },
        "auth": self.authid,
        "id": 1
        }
    print "获取GroupID报文："
    print data
    groups = self.postData(data)
    groups = eval(groups)
    gpid = groups['result']
#    gpid = []
#    for i in groups['result']:
#      gpid.append(i['groupid'])
    return gpid

#获取hostid
  def getHostID(self,ip):
    data = {
      "jsonrpc": "2.0",
      "method": "host.get",
      "params": {
              "output": [
                  "hostid",
                  "host"
              ],
              "filter": {
                  "host": ip
              }
              },
          "id": 1,
      "auth": self.authid,
    } 
    print "获取HostID报文："
    print data
    host = self.postData(data)
    host = eval(host)
    hostid = host['result'][0]['hostid']
    return hostid

#判断是否存在默认地SNMP Interfaceid
  def isExistSnmpIntf(self,ip):
    data = {
      "jsonrpc": "2.0",
      "method": "hostinterface.get",
      "params": {
        "output": "interfaceid",
        "filter": {
          "ip": ip,
          "type": 2
        }
      }
    }
    print "查看是否存在Snmp Interface："
    print data
    r = self.postData(data)
    if r.text[result]:
      print "exist！"
      return True
    else:
      print "no exist!"
      return False

#获取interfaceid
  def getInterfaceID(self,ip,port):
    data = {
        "jsonrpc": "2.0",
        "method": "hostinterface.get",
        "params": {
            "output": "interfaceid",
            "filter": {
                "ip": ip,
                "port": port   
            }
    
        },
        "auth": self.authid,
        "id": 1
    } 
    print "获取InterfaceID报文："
    print data
    interface = self.postData(data)
    interface = eval(interface)
    if interface['result']:
      ifid = interface['result'][0]['interfaceid']
      return ifid
    else:
      print "no such interfaceid, please check again!"

#获取applicationid
  def getApplicationID(self,name,hostid):
    name = name.split(',')
    data = {
        "jsonrpc": "2.0",
        "method": "application.get",
        "params": {
            "output": "applicationid",
            "filter": {
                "name": name,
                "hostid": hostid,
            }
            
        },
        "auth": self.authid,
        "id": 1
    }
    print "获取ApplicationID报文："
    print data
    applications = self.postData(data)
    applications = eval(applications)
#    appid = applications['result']
    appid = []
    for i in applications['result']:
      appid.append(i['applicationid'])
    print appid
    return appid

#获取snmp oid
  def getSnmpOid(self,ip,port,oid):
    cm = "snmpwalk -v 1 -c public " + ip + ":" + port + " " + oid
    (status,result) = commands.getstatusoutput(cm)
    n = len(result.split('\n')) 
    if status == 0:
        if n == 1:
          id = result[result.find("enterprises.")+11:result.rfind(" = ")]
          woid = ".1.3.6.1.4.1" + id
          print "Snmp Oid为："
          print woid
          return woid
        else:
          r = result.split('\n')
          name = commands.getoutput("snmpwalk -v 1 -c public "+ ip + ":" + port + " " + ".1.3.6.1.4.1.140.625.190.1.5")
          name = name.split('\n')
          x = 0
          woid = {}
          for i in name:
            jdbcname = i[i.find("com.bea:Name=")+13:i.rfind(",ServerRuntime")]
            m = r[x]
            woid[jdbcname] = ".1.3.6.1.4.1" + m[m.find("enterprises.")+11:m.rfind(" = ")]
            x = x + 1
          print "DB Snmp Oid 为："
          print woid
          return woid
#获取weblogic http当前连接数的snmp oid
  def getHttpSnmpOid(self,ip,port):
    cm = "snmpwalk -v 1 -c public " + ip + ":" + port + " .1.3.6.1.4.1.140.625.366.1.15"
    (status,result) = commands.getstatusoutput(cm)
    if status == 0:
      r = result.split('\n')
      for i in r:
        if "\"Default[http]\"" in i:
          woid =  i[i.find("140.625.366.1.15.") + 17:i.find(" = STRING")]
          woid = ".1.3.6.1.4.1.140.625.366.1.40." + woid
          print "HttpConnectionsCount OID 为："
          print woid
          break
      return woid
    else:
      print "please check the commands:"
      print cm

#获取weblogic sessions当前会话数snmpoid
  def getSessionSnmpOid(self,ip,port,app):
    cm = "snmpwalk -v 1 -c public " + ip + ":" + port + " .1.3.6.1.4.1.140.625.430.1.25"
    (status,result) = commands.getstatusoutput(cm)
    if status == 0:
      r = result.split('\n')
      for i in r:
        if app in i:
          woid = i[i.find("140.625.430.1.25.") + 17:i.find(" = STRING")]
          woid = ".1.3.6.1.4.1.140.625.430.1.50." + woid
          deployoid = ".1.3.6.1.4.1.140.625.430.1.30." + woid
          print "SessionsCurrentCount OID为："
          print woid
          break
      return woid
    else:
      print "please check the commands:"
      print cm


if __name__ == "__main__":
  a = zabbix()
  a.login()
#  a.getSnmpOid("10.133.210.128","17003",".1.3.6.1.4.1.140.625.340.1.52")
  a.getHttpSnmpOid("10.133.210.128","17003",".1.3.6.1.4.1.140.625.366.1.15")
#  a.getApplicationID("Web_Url,DBConnectionRuntimeState","10141")
#  a.getInterfaceID("10.133.210.128","18001")
#  a.getHostID("10.133.210.128")
#  a.isExistSnmpIntf("10.133.214.106")
#  a.createSnmpIntf("10.133.214.106","17003")
#  a.getHostGroupID("FS_CLUB,Linux servers")
#  a.getTemplateID("Template_CLUB_OS_Linux")
