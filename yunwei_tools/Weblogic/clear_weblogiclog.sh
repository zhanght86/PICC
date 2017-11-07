#!/usr/bin/env bash
#coding:utf-8

#给定domain存放的路径
DOMAINS_HOME=$1

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

