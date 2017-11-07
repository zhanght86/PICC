一、SHELL 脚本命令规范
	1，全局变量名：大写字母；
	2，局部变量名：小写字母；
	3，方法名：驼峰命名法；
	4，需要替换的字符串：大写字母；（模板文件）

二、文件及目录说明
	1，weblogic_func.sh 里面存放需要用到的函数；
	2，interact_createDomain.sh 为交互提示创建Domain的脚本；
		获取输入 - 创建主管Domain - 添加启动和重启脚本
	3，batch_createDomain.sh 为批量创建Domian的脚本；
	4，templates目录里面存放的是标准模板文件，创建Domian时替换其中的值；
	5，tmp目录里面存放临时生成的文件
	6，logs目录里面存放日志文件

三、使用说明
1,批量创建weblogc主管及受管
配置文件：createMessage.txt
	配置文件里面有字段说明，照着填就行

执行文件：batch_createDomain.sh
	先把配置文件填好，然后执行，
	执行完成后会生成：
	1，默认目录$HOME/bea/user_projects/domains 生成domain
	2，$Domain_Home/bin下生成主受管启动脚本，直接执行启动脚本即可创建密码文件
	3，$HOME/restart_shell目录下生成重启脚本
	4，./tmp下生成受管创建脚本，执行sh $HOME/Oracle/.../wlst.sh filename.py 创建受管。（需要注意的是，创建受管必须先启动主管）

2，单个Domain交互式创建
执行文件：interact_createDomain.sh
	输入 domain名、domain模式、端口号三个参数完成创建

注：默认的domain创建路径是$HOME/bea/user_projects/domains
	./logs下会有日志输出，暂时没有把日志输出考虑完善，待以后修改
	weblogic_func.sh文件里面专门存放shell函数，以供其它脚本调用
	直接上传到对应主机，解压执行对应脚本即可

threadPoolRuntimeHoggingThreadCount
jvmRuntimeHeapFreePercent
serverRuntimeState
 
jdbcConnectionPoolRuntimeActiveConnectionsCurrentCount      
jdbcConnectionPoolRuntimeLeakedConnectionCount
jdbcConnectionPoolRuntimeState


	

