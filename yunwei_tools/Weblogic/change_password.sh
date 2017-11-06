#！/usr/bin/env bash
#coding：utf-8

#输入domain名称确定默认domainname路径
#输入用户名和密码
domainname=$1
username=$2
password=$3
ORACLE_HOME=
time=`date "+%Y%m%d_%H%M%S"`

BASE_DIR=$(cd `dirname $0`;pwd)
SHELL_NAME=`basename $0`
LOG_DIR=${BASE_DIR}/logs
. ${BASE_DIR}/weblogic_func.sh

logging "开始修改${domainname}的密码："
logging "用户为：${username}"
logging "密码为：${password}"

cd $HOME/bea/user_projects/domains/$domainname

logging "备份初始密钥文件"
mv security/DefaultAuthenticatorInit.ldift security/DefaultAuthenticatorInit.ldift_${time}
if [ -n "${ORACLE_HOME}" ]
    then
    java -classpath ${ORACLE_HOME}/wlserver_10.3/server/lib/weblogic.jar weblogic.security.utils.AdminAccount $username $password security
else
    java -classpath ${HOME}/Oracle/Middleware/wlserver_10.3/server/lib/weblogic.jar weblogic.security.utils.AdminAccount $username $password security/
fi

logging "开始修改boot.properties"
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
