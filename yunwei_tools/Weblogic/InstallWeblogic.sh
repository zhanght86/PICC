#!/usr/bin/bash
JAVA_HOME=/usr/java/jdk1.6.0_45
WEBLOGIC_JAR=/home/weblogic/wls1036_generic.jar
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME WEBLOGIC_JAR PATH

/usr/bin/expect <<-EOF


spawn java -jar $WEBLOGIC_JAR
expect "*Enter \[Exit\]\[Next\]>"
send "\r"
#weblogic主目录
expect "Enter new Middleware Home OR \[Exit\]\[Previous\]\[Next\]>"
send "\r"
#取消自动更新
expect "Enter index number to select OR \[Exit\]\[Previous\]\[Next\]>" 
send "3\r"
expect "Enter \[Yes\]\[No\]?"
send "no\r"
expect "Enter \[Yes\]\[No\]?"
send "yes\r"
expect "Enter index number to select OR \[Exit\]\[Previous\]\[Next\]>"
send "\r"
#典型or自定义
expect "Enter index number to select OR \[Exit\]\[Previous\]\[Next\]>"
send "\r"
#选择java路径
expect "Enter 1 to add or >= 2 to toggle selection  OR \[Exit\]\[Previous\]\[Next\]>"
send "\r"
#选择安装路径
expect "Enter index number to select OR \[Exit\]\[Previous\]\[Next\]>"
send "\r"
#确认安装
expect "Enter \[Exit\]\[Previous\]\[Next\]>"
send "\r"
#完成安装
expect "Press \[Enter\] to continue or type \[Exit\]>"
send "\r"

expect eof 
EOF