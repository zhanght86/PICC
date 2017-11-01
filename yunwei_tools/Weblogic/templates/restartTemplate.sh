#!/usr/bin/bash
#coding:utf-8

Server_Name=SERVER_NAME
Domain_Name=DOMAIN_NAME
if command -v java
    then
    JAVA=`command -v java`
else
    echo "no java in the PATH"
    JAVA=java
fi

pid=`ps -ef|grep ${JAVA}|grep ${Server_Name}|awk '{print $2}'`
if [ -n "$pid" ]
then
	echo "kill ${Server_Name}!"
	kill -9 $pid
else
	echo "no found such process!"
fi

sleep 3
sh ${HOME}/bea/user_projects/domains/${Domain_Name}/bin/${Server_Name}_start.sh