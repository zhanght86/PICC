Rem  ----------1. �޸��ļ��嵥list_zkr.txt-----------------

rem �����̷�
set disk=d:

rem �����滻�ű�������õ�λ��
set script_disk=d:
Set  replace_script_path=%script_disk%\SOFTWARE\ͳһ�������\������������

rem ������������Ŀ¼
set update_package_root=D:\update_package

rem ���ù����ռ�
set workspace=zkr

rem ����ģ������
set module=zkr

rem  ------------------------------------------
rem  ����������Ҫ�Զ���
rem  ------------------------------------------

rem ƴģ������г���Ŀ¼����webapps 
set webapps_path=%disk%\%workspace%\%module%
echo %webapps_path%

Rem �������rar����list_weixin.txt���ŵ������ռ��upgrade_workingĿ¼��
Set  upgrade_working_path=%update_package_root%\temp


rem �޸�list_weixin.txt�ļ���ʹ���Ϊ������rar����
%script_disk%
Cd %replace_script_path%
cscript replace.vbs "%upgrade_working_path%\list_zkr.txt" ".java" ".class"
cscript replace.vbs "%upgrade_working_path%\list_zkr.txt" "Modified" ""

cscript replace.vbs "%upgrade_working_path%\list_zkr.txt" "src/main/java" "target/weixin-0.0.1-SNAPSHOT/WEB-INF/classes" 

cscript replace.vbs "%upgrade_working_path%\list_zkr.txt" "Added" ""

Rem  --------------2.  ��webapp���棬��jar��---------------------
%disk%
cd %webapps_path%
jar -cvfM %upgrade_working_path%\%module%.rar @%upgrade_working_path%\list_zkr.txt 

rem   -------------3.  �����������ļ���---------------------------

rem �������������������ļ��У���������򲻴���
set yymm_directory=%update_package_root%\%module%\%date:~0,10%
mkdir %yymm_directory%

rem �������ļ����£����ݲ�ͬ��ʱ��㣨24Сʱ�ƣ�������ʱ����ļ���,ȡʱ��ǰ2λ��
set t=%time:~0,2%
rem 10��֮ǰ��A�� 10��֮����B
if %t% lss 10 goto A 
if %t% geq 10 goto B 


rem  --------------4. ��ѹ��------------------
 
:A
Cd  %upgrade_working_path%
echo %upgrade_working_path%
dir
jar -xvf %module%.rar 
set timestamp_directory=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~1,1%%time:~3,2%%time:~6,2%
echo %yymm_directory%\%timestamp_directory%\%module%
echo %upgrade_working_path%\
xcopy  src\*.* %yymm_directory%\%timestamp_directory%\%module%\src\*.* /s
echo ִ��A
goto D

:B
Cd  %upgrade_working_path%
echo %upgrade_working_path%
dir
jar -xvf %module%.rar 
set timestamp_directory=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%
xcopy  *.* %yymm_directory%\%timestamp_directory%\%module%\*.* /s
echo ִ��B
goto D

:D 
rem--------------5. ɾ��update_package\temp�µ�list�ļ�������rar���ͽ�ѹ��-------------------
cd  %upgrade_working_path%
del %module%.rar
rd /s /q %module%
pause
call E:\�п���Ƽ��ɷ����޹�˾\�ƶ��ű�����\zkr.bat