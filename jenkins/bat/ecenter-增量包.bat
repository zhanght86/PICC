Rem  ----------1. 修改文件清单list_ecenter.txt-----------------

rem 设置盘符
set disk=d:

rem 设置替换脚本程序放置的位置
set script_disk=d:
Set  replace_script_path=%script_disk%\SOFTWARE\统一打包工具\打增量包工具

rem 设置升级包根目录
set update_package_root=D:\update_package

rem 设置工作空间
set workspace=personalCenter

rem 设置模块名称
set module=ecenter

rem  ------------------------------------------
rem  上述参数需要自定义
rem  ------------------------------------------

rem 拼模块的运行程序目录，到webapps 
set webapps_path=%disk%\%workspace%\%module%
echo %webapps_path%

Rem 打的增量rar包和list_ecenter.txt都放到工作空间的upgrade_working目录下
Set  upgrade_working_path=%update_package_root%\temp


rem 修改list_ecenter.txt文件，使其可为打增量rar服务
%script_disk%
Cd %replace_script_path%
cscript replace.vbs "%upgrade_working_path%\list_ecenter.txt" ".java" ".class"
cscript replace.vbs "%upgrade_working_path%\list_ecenter.txt" "Modified" ""

cscript replace.vbs "%upgrade_working_path%\list_ecenter.txt" "src/main/java" "target/ecenter/WEB-INF/classes" 

cscript replace.vbs "%upgrade_working_path%\list_ecenter.txt" "Added" ""

Rem  --------------2.  在webapp下面，打jar包---------------------
%disk%
cd %webapps_path%
jar -cvfM %upgrade_working_path%\%module%.rar @%upgrade_working_path%\list_ecenter.txt 

rem   -------------3.  创建升级包文件夹---------------------------

rem 创建以年月日命名的文件夹，如果已有则不创建
set yymm_directory=%update_package_root%\%module%\%date:~0,10%
echo %yymm_directory%
mkdir %yymm_directory%

rem 在年月文件夹下，根据不同的时间点（24小时制）来创建时间戳文件夹,取时间前2位，
set t=%time:~0,2%
rem 10点之前走A， 10点之后走B
if %t% lss 10 goto A 
if %t% geq 10 goto B 


rem  --------------4. 解压包------------------
 
:A
Cd  %upgrade_working_path%
echo %upgrade_working_path%
dir
jar -xvf %module%.rar 
set timestamp_directory=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~1,1%%time:~3,2%%time:~6,2%
echo %yymm_directory%\%timestamp_directory%\%module%
echo %upgrade_working_path%\
xcopy  src\*.* %yymm_directory%\%timestamp_directory%\%module%\src\*.* /s
echo 执行A
goto D

:B
Cd  %upgrade_working_path%
echo %upgrade_working_path%
dir
jar -xvf %module%.rar 
set timestamp_directory=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%
xcopy  *.* %yymm_directory%\%timestamp_directory%\%module%\*.* /s
echo 执行B
goto D

:D 
rem--------------5. 删除update_package\temp下的list_ecenter文件，增量rar包和解压包-------------------
cd  %upgrade_working_path%
del %module%.rar
rd /s /q %module%
pause
E:
CD 中科软科技股份有限公司\移动脚本命令
 move_ecenter.bat