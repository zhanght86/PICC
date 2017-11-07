#!/bin/sh
export JAVA_HOME=/home/picc_micro/jdk1.7.0_79
export JRE_HOME=/home/picc_micro/jdk1.7.0_79/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH:$ZOOKEEPERPATH/bin

java -Xms1024m -Xmx1024m -XX:ParallelGCThreads=8 -XX:PermSize=256m -XX:MaxPermSize=512m -Xss256k -XX:-DisableExplicitGC -XX:+UseComp
ressedOops -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled  -jar /home/picc_micro/microworkareas/micro_redis/micro-service-red
is.jar

#!/bin/sh
#utf-8
echo --------- config ENVIRONMENT -----------------------
export JAVA_HOME=/home/picc_micro/jdk1.7.0_79
export JRE_HOME=/home/picc_micro/jdk1.7.0_79/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH:$ZOOKEEPERPATH/bin
echo --------- finished ENVIRONMENT ---------------------

echo ------------------config JAVA_OPTS------------------
#set MEMORY
JAVA_OPTS="-Xms1024m -Xmx2014m -XX:PermSize=256m -XX:MaxPermSize=512m -Xss256k"

#set OTHERS_OPTIONS
JAVA_OPTS="$JAVA_OPTS -XX:ParallelGCThreads=8 -XX:-DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+UseCompressedOops  -XX:+CMSParallelRemarkEnabled"
echo ------------------finished JAVA_OPTS-----------------

java $JAVA_OPTS -jar /home/picc_micro/microworkareas/micro_redis/micro-service-redis.jar