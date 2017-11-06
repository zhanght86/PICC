#!${ORACLE_HOME}/wlserver_10.3/common/bin/wlst.sh
#coding:utf-8

import sys
import time
from weblogic.management.security.authentication import UserPasswordEditorMBean

#连接weblogic console 需要提供 username、password、url，修改需要提供new_password
username=sys.argv[1]
old_password=sys.argv[2]
new_password=sys.argv[3]
ip=sys.argv[4]
port=sys.argv[5]
url="t3://" +　ip + ":" + port                  
logfile=sys.path[0] + "/logs/changepassword" + time.strftime('%Y%m%d-%H%M%S',time.localtime()) + ".log"

def changePass(username,old_password,new_password,url=url):
    try:
        connect(username,old_password,url)
        print "Changing password ..."
        atnr=cmo.getSecurityConfiguration().getDefaultRealm().lookupAuthenticationProvider("DefaultAuthenticator")
        try:
            atnr.changeUserPassword(username,old_password,new_password)
        except:
            print >> log,"failed to change password in" + url
        print "Changed password successfully"
        disconnect()
    except:
        print >> log,"failed to change password in " + url

log=open(logfile,'w')
changePass(username=username,old_password=old_password,new_password=new_password,url=url)
log.close()
exit()
