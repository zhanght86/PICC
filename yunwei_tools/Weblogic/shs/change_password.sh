#！/usr/bin/env bash
#coding：utf-8

. ${EPICC_FUNCTION}
time=`date "+%Y%m%d_%H%M%S"`

#oracle home
if [ -n "$ORACLE_HOME" ]
    then logging "Oracle Home is $ORACLE_HOME" 
else
    ORACLE_HOME=${HOME}/Oracle/Middleware
    logging "Oracle Home is $ORACLE_HOME" 
fi

#输入domain名称确定默认domainname路径
#输入用户名和密码
logging "请输入要修改的domain名称："
read domainname
logging "请输入weblogic 用户名："
read username   
logging "请输入新密码"
read password

logging "开始修改$HOME/bea/user_projects/domains/${domainname}的密码："
logging "用户为：${username}"
logging "密码为：${password}"
logging "请确认："
read flag
confirm $flag

cd $HOME/bea/user_projects/domains/$domainname

mv security/DefaultAuthenticatorInit.ldift security/DefaultAuthenticatorInit.ldift_${time}
logging "备份初始密钥文件success!"
java -classpath ${ORACLE_HOME}/wlserver_10.3/server/lib/weblogic.jar weblogic.security.utils.AdminAccount $username $password security
logging "创建新密码文件success!"

#find ./servers -name boot.properties -exec printf "username=${username}\npassword=${password}" > {} \;
cd servers
for i in `find . -name boot.properties`;
do
    logging "备份密码文件 ${i}"
    cp $i ${i}_$time;
    printf "username=${username}\npassword=${password}\n" > $i;
    logging "重置${i} over!"
done

#备份data目录
find . -type d -name data -exec mv {} {}_$time \;
logging "备份data目录 success！"

logging "${domainname} 密码修改完成!"
