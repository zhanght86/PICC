#脚本说明，批量添加zabbix监控分为三个文件：
#1，zabbix.py -- 里面定义了通过zabbix api添加主机、Item、Trigger和获取zabbix其它信息及获取snmp oid的方法
#2，createZabbix.py -- 该文件为实际执行的脚本，调用zabbix.py里面的方法，读取配置文件添加zabbix监控。
#	命名规则：Host 为ip，Item 为 $itemname + port， Trigger为 Check_ + $itemname
#	需要注意的是该脚本中有三个函数，添加Host、添加Item、添加Trigger,使用时注释掉不需要使用的函数
#3，Readme.txt  -- 脚本说明及配置文件，配置规则如下：
#a,使用"#"注释行
#b,字段依次为：主机ip - server端口 - 主机所属组（多个组以逗号隔开）- 主机模板（多个模板用逗号隔开）- snmp监控端口 - 应用名称 - yes(随便加的字段)
#c,例如：10.133.214.106 - 7003 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17003 - crmweb - yes
#注：三个文件必须位于同一目录下，编辑好配置文件后，在creteZabbix.py最后三行注释掉不需要使用的函数执行"python createZabbix.py"即可。

10.133.210.13 - 7003 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17003 - clubweb - yes
10.133.210.14 - 7003 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17003 - clubweb - yes
10.133.210.15 - 7003 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17003 - clubweb - yes
10.133.210.16 - 7003 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17003 - clubweb - yes
10.133.210.13 - 7004 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17004 - merchant - yes
10.133.210.14 - 7004 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17004 - merchant - yes
10.133.210.15 - 7004 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17004 - merchant - yes
10.133.210.16 - 7004 - FS_CLUB,Linux servers - Template_CLUB_OS_Linux - 17004 - merchant - yes

