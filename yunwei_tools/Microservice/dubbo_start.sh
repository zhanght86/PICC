#!/bin/bash
echo ------------------start dubbo provider server------------------
echo ------------------config classpath------------------
_classpath=../conf
cd ../lib
libjars=$(echo *.jar|sed 's/ /:/g')
echo jars=$libjars 
_classpath=${_classpath}:${libjars}
echo classpath=${_classpath}

echo ------------------config JAVA_OPTS------------------
#--------------set java options--------------
JAVA_OPTS="-Xms256m -Xmx1024m"
#--------------set dubbo options--------------
JAVA_OPTS="${JAVA_OPTS} -Ddubbo.properties.file=../conf/dubbo.properties"
#--------------set jmx options--------------
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=17180 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
echo JAVA_OPTS=${JAVA_OPTS}
echo ------------------start server------------------
nohup java ${JAVA_OPTS} -classpath ${_classpath} com.alibaba.dubbo.container.Main >> /log/mailService/yz_148_31_mailService_7180.out &