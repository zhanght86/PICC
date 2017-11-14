#!/usr/bin/env bash
#coding:utf-8
#create by chenqi


GET_XML_CODE_NUMBER_MESSAGE()   #--抽取配置文件节点数信息
{
XML_CODE_NUMBER_MESSAGE=`sed -n "/<$1>/=" $2`
echo "$XML_CODE_NUMBER_MESSAGE"
}

GET_XML_CONFIG_MESSAGE()   #--抽取配置文件配置信息
{
XML_CONFIG_MESSAGE=`sed -n "$1,$2 p" $3 | grep "<$4>"`
XML_CONFIG_MESSAGE=`echo ${XML_CONFIG_MESSAGE#*\<$4\>}`
XML_CONFIG_MESSAGE=`echo ${XML_CONFIG_MESSAGE%\<\/$4\>}`

#echo "#sed -n \"$1,$2 p\" $3 | grep \"<$4>\" $XML_MESSAGE"
echo "$XML_CONFIG_MESSAGE"
}

if [ -n "$Domain_Path" ]
    then echo "Domain 路径为：$Domain_Path"
else
    echo "请输入Domain Path："
    read Domain_Path
fi

#read Domain_Path
echo "<系统提示: 开始获取weblogic信息!>"
sleep 2
echo "<系统提示: weblogic信息如下:>"
echo "-----------------------------------------------------------domain_message-----------------------------------------------------------"

echo "<Domain_Path>: $Domain_Path"

Domain_Config_Path="$Domain_Path/config"                                                                               #--domain配置文件路径
Domain_Config_Name="config.xml"                                                                                        #--domain配置文件名



Admin_Server_Name=`grep "<admin-server-name>" $Domain_Config_Path/$Domain_Config_Name`                                 #--获取sever名字
Admin_Server_Name=`echo ${Admin_Server_Name#*\<admin-server-name\>}`
Admin_Server_Name=`echo ${Admin_Server_Name%\<\/admin-server-name\>}`
echo "<Server_Name>: $Admin_Server_Name"

Domain_Version=`grep "<domain-version>" $Domain_Config_Path/$Domain_Config_Name`                                       #--获取版本号
Domain_Version=`echo ${Domain_Version#*\<domain-version\>}`
Domain_Version=`echo ${Domain_Version%\<\/domain-version\>}`
echo "<Domain_Version>: $Domain_Version"

Domain_Mode=`grep "<production-mode-enabled>" $Domain_Config_Path/$Domain_Config_Name`                                 #--获取domain模式
Domain_Mode=`echo ${Domain_Mode#*\<production-mode-enabled\>}`
Domain_Mode=`echo ${Domain_Mode%\<\/production-mode-enabled\>}`
if [ "$Domain_Mode" == "true" ]
then
    echo "<Domain_Mode>: Production-Mode" 
else
    echo "<Domain_Mode>: Development-Mode"
fi

echo "-----------------------------------------------------------domain_message-----------------------------------------------------------"
echo "-----------------------------------------------------------deployment_message-----------------------------------------------------------"

Deployment_Start_Number=`GET_XML_CODE_NUMBER_MESSAGE "app-deployment" $Domain_Config_Path/$Domain_Config_Name ;`                         #--获取所有部署开始节点
Deployment_Start_Sum=`grep -c "<app-deployment>" $Domain_Config_Path/$Domain_Config_Name`                                               #--获取所有部署开始节点总数
Deployment_End_Number=`GET_XML_CODE_NUMBER_MESSAGE "\/app-deployment" $Domain_Config_Path/$Domain_Config_Name ;`                         #--获取所有部署结束节点
Deployment_End_Sum=`grep -c "<\/app-deployment>" $Domain_Config_Path/$Domain_Config_Name`                                               #--获取所有部署结束节点总数

Deployment_Online_Number="1"

while [ "$Deployment_Start_Sum" = "$Deployment_End_Sum" ] && [ "$Deployment_Online_Number" -lt "`expr $Deployment_Start_Sum + 1`" ]
do

Get_Deployment_Start_Number=`echo $Deployment_Start_Number|awk '{print $'$Deployment_Online_Number' }'`       #--从所有部署开始节点中获取当前所需节点数的信息
Get_Deployment_End_Number=`echo $Deployment_End_Number|awk '{print $'$Deployment_Online_Number' }'`           #--从所有部署结束节点中获取当前所需节点数的信息


Deployment_Name=`GET_XML_CONFIG_MESSAGE $Get_Deployment_Start_Number $Get_Deployment_End_Number $Domain_Config_Path/$Domain_Config_Name "name" ;`            #--获取部署包名称
Deployment_Type=`GET_XML_CONFIG_MESSAGE $Get_Deployment_Start_Number $Get_Deployment_End_Number $Domain_Config_Path/$Domain_Config_Name "module-type" ;`        #--获取部署包类型
Deployment_Path=`GET_XML_CONFIG_MESSAGE $Get_Deployment_Start_Number $Get_Deployment_End_Number $Domain_Config_Path/$Domain_Config_Name "source-path" ;`          #--获取部署包部署路径
Deployment_Target=`GET_XML_CONFIG_MESSAGE $Get_Deployment_Start_Number $Get_Deployment_End_Number $Domain_Config_Path/$Domain_Config_Name "target" ;`          #--获取部署包目标

echo "Deployment_Package<$Deployment_Online_Number>:"
echo "<Deployment_Name>: $Deployment_Name"
echo "<Deployment_Type>: $Deployment_Type"
echo "<Deployment_Path>: $Deployment_Path"
echo "<Deployment_Target>: $Deployment_Target"
echo ""
#sleep 1
Deployment_Online_Number=`expr $Deployment_Online_Number + 1`

done

echo "-----------------------------------------------------------deployment_message-----------------------------------------------------------"
echo "-----------------------------------------------------------datasource_message-----------------------------------------------------------"

Connection_Pool_Start_Number=`GET_XML_CODE_NUMBER_MESSAGE "jdbc-system-resource" $Domain_Config_Path/$Domain_Config_Name ;` #--获取所有连接池开始节点
Connection_Pool_Start_Sum=`grep -c "<jdbc-system-resource>" $Domain_Config_Path/$Domain_Config_Name`                        #--获取所有连接池开始节点总数
Connection_Pool_End_Number=`GET_XML_CODE_NUMBER_MESSAGE "\/jdbc-system-resource" $Domain_Config_Path/$Domain_Config_Name ;` #--获取所有连接池结束节点
Connection_Pool_End_Sum=`grep -c "<\/jdbc-system-resource>" $Domain_Config_Path/$Domain_Config_Name`                        #--获取所有连接池结束节点总数

#echo $Connection_Pool_Start_Number
#echo $Connection_Pool_Start_Sum
#echo $Connection_Pool_End_Number
#echo $Connection_Pool_End_Sum

Connection_Pool_Online_Number="1"

while [ "$Connection_Pool_Start_Sum" = "$Connection_Pool_End_Sum" ] && [ "$Connection_Pool_Online_Number" -lt "`expr $Connection_Pool_Start_Sum + 1`" ]
do

Get_Connection_Pool_Start_Number=`echo $Connection_Pool_Start_Number|awk '{print $'$Connection_Pool_Online_Number' }'` #--从所有连接池开始节点中获取当前所需节点数的信息
Get_Connection_Pool_End_Number=`echo $Connection_Pool_End_Number|awk '{print $'$Connection_Pool_Online_Number' }'`     #--从所有连接池结束节点中获取当前所需节点数的信息

Connection_Pool_Name=`GET_XML_CONFIG_MESSAGE $Get_Connection_Pool_Start_Number $Get_Connection_Pool_End_Number $Domain_Config_Path/$Domain_Config_Name "name" ;` #--获取连接池名称
DataSource_Name=`GET_XML_CONFIG_MESSAGE $Get_Connection_Pool_Start_Number $Get_Connection_Pool_End_Number $Domain_Config_Path/$Domain_Config_Name "descriptor-file-name" ;` #--获取数据源文件名称
DataSource_Target=`GET_XML_CONFIG_MESSAGE $Get_Connection_Pool_Start_Number $Get_Connection_Pool_End_Number $Domain_Config_Path/$Domain_Config_Name "target" ;` #--获取数据源目标

Check_Connection_Pool_Type=`grep "<data-source-list>" $Domain_Config_Path/$DataSource_Name`
if [ -n "$Check_Connection_Pool_Type" ]
then
    Connection_Pool_Type="Multi"
else
    Connection_Pool_Type="Single"
fi

echo "#Data_Source<""$Connection_Pool_Online_Number"">:"
echo "<Data_Source_Name>: $Connection_Pool_Name"
echo "<Data_Source_Type>: $Connection_Pool_Type"
echo "<Data_Source_File>: $Domain_Config_Path/$DataSource_Name"
echo "<Data_Source_Target:> $DataSource_Target"


DataBase_IP=`grep "<url>" $Domain_Config_Path/$DataSource_Name`                                 #--获取数据库IP
DataBase_IP=`echo ${DataBase_IP#*\<url\>}`
DataBase_IP=`echo ${DataBase_IP%\<\/url\>}`
DataBase_IP1=`echo $DataBase_IP|awk -F "HOST=" '{print $2 }'`
DataBase_IP1=`echo $DataBase_IP1|awk -F ")" '{print $1 }'`
DataBase_IP2=`echo $DataBase_IP|awk -F "HOST=" '{print $3 }'`
DataBase_IP2=`echo $DataBase_IP2|awk -F ")" '{print $1 }'`
echo "<DataBase_IP1>: $DataBase_IP1"
echo "<DataBase_IP2>: $DataBase_IP2"

DataBase_Port=`grep "<url>" $Domain_Config_Path/$DataSource_Name`                                 #--获取数据库端口号
DataBase_Port=`echo ${DataBase_Port#*\<url\>}`
DataBase_Port=`echo ${DataBase_Port%\<\/url\>}`
DataBase_Port1=`echo $DataBase_Port|awk -F "PORT=" '{print $2 }'`
DataBase_Port1=`echo $DataBase_Port1|awk -F ")" '{print $1 }'`
DataBase_Port2=`echo $DataBase_Port|awk -F "PORT=" '{print $3 }'`
DataBase_Port2=`echo $DataBase_Port2|awk -F ")" '{print $1 }'`
echo "<DataBase_Port1>: $DataBase_Port1"
echo "<DataBase_Port2>: $DataBase_Port2"

DataBase_Instance=`grep "<url>" $Domain_Config_Path/$DataSource_Name`                               #--获取数据库实例名
DataBase_Instance=`echo ${DataBase_Instance#*\<url\>}`
DataBase_Instance=`echo ${DataBase_Instance%\<\/url\>}`
DataBase_Instance=`echo $DataBase_Instance|awk -F "SERVICE_NAME=" '{print $2 }'`
DataBase_Instance=`echo $DataBase_Instance|awk -F ")" '{print $1}'`
echo "<DataBase_Instance>: $DataBase_Instance"

DataBase_User=`grep "<value>" $Domain_Config_Path/$DataSource_Name`                                 #--获取数据库用户名
DataBase_User=`echo ${DataBase_User#*\<value\>}`
DataBase_User=`echo ${DataBase_User%\<\/value\>}`
echo "<DataBase_User>: $DataBase_User"

JNDI_Name=`grep "<jndi-name>" $Domain_Config_Path/$DataSource_Name`                                 #--获取数据库实例名
JNDI_Name=`echo ${JNDI_Name#*\<jndi-name\>}`
JNDI_Name=`echo ${JNDI_Name%\<\/jndi-name\>}`
echo "<JNDI_Name>: $JNDI_Name"

Min_Capacity=`grep "<min-capacity>" $Domain_Config_Path/$DataSource_Name`                           #--获取数据源初始值
Min_Capacity=`echo ${Min_Capacity#*\<min-capacity\>}`
Min_Capacity=`echo ${Min_Capacity%\<\/min-capacity\>}`
if [ -n "$Min_Capacity" ]
then
    echo "<Min_Capacity>: $Min_Capacity"
else
    echo "<Min_Capacity>: default"
fi

Initial_Capacity=`grep "<initial-capacity>" $Domain_Config_Path/$DataSource_Name`                   #--获取数据源增长值
Initial_Capacity=`echo ${Initial_Capacity#*\<initial-capacity\>}`
Initial_Capacity=`echo ${Initial_Capacity%\<\/initial-capacity\>}`
if [ -n "$Initial_Capacity" ]
then
    echo "<Initial_Capacity>: $Initial_Capacity"
else
    echo "<Initial_Capacity>: default"
fi

Max_Capacity=`grep "<max-capacity>" $Domain_Config_Path/$DataSource_Name`                           #--获取数据源最大值
Max_Capacity=`echo ${Max_Capacity#*\<max-capacity\>}`
Max_Capacity=`echo ${Max_Capacity%\<\/max-capacity\>}`
if [ -n "$Max_Capacity" ]
then
    echo "<Max_Capacity>: $Max_Capacity"
else
    echo "<Max_Capacity>: default"
fi
echo ""

#sleep 1
Connection_Pool_Online_Number=`expr $Connection_Pool_Online_Number + 1`

done

echo "-----------------------------------------------------------datasource_message-----------------------------------------------------------"
echo "<系统提示: 服务启动倒计时!>"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"