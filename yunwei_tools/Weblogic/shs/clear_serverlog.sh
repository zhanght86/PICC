#!/usr/bin/env bash
#coding:utf-8

. ${EPICC_FUNCTION}

#给定domain存放的路径
if [ -n "$DOMAINS_HOME" ]
    then logging "Domain 路径为：$DOMAINS_HOME" 
else
    DOMAINS_HOME=${HOME}/bea/user_projects/domains
    logging "默认Domain 路径为：$DOMAINS_HOME" 
fi

echo "清理${DOMAINS_HOME}/logs下的日志："
for i in `find $DOMAINS_HOME/*/logs -name *.log -mtime +7`
do
    echo $i
    rm -f $i
done

echo "清理${DOMAINS_HOME}/*domain/servers/*server/logs 下的日志："
for i in `find ${DOMAINS_HOME}/*/servers/*/logs -name *.log -mtime +7`
do
    echo $i
    rm -f $i
done