Rem  ----------1. �޸��ļ��嵥list_EbsWeb.txt-----------------

rem �����̷�
set disk=d:

rem �����滻�ű�������õ�λ��
set script_disk=d:
Set  replace_script_path=%script_disk%\SOFTWARE\ͳһ�������\������������

rem ������������Ŀ¼
set update_package_root=D:\update_package

rem ���ù����ռ�
set workspace=Ebsworkspace

rem ����ģ������
set module=PICCEbsWebProject_yanshou1

rem  ------------------------------------------
rem  ����������Ҫ�Զ���
rem  ------------------------------------------




rem ƴģ������г���Ŀ¼����webapps 
set webapps_path=%disk%\%workspace%\%module%
echo %webapps_path%


Rem �������rar����list_EbsWeb.txt���ŵ������ռ��upgrade_workingĿ¼��
Set  upgrade_working_path=%update_package_root%\temp


rem �޸�list_EbsWeb.txt�ļ���ʹ���Ϊ������rar����
%script_disk%
Cd %replace_script_path%
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" ".java" ".class"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "Modified" ""

cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/cardWebservice/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/dispatch_3G/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/endorse/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/proposal/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/ebsAdmin/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/admin/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/authority/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/insurance/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/bill99/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/card/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/claim/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/consultation/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/dispatcher/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/documentaryfee/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/investigation/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/signinfomanage/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/ticketpolicy/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/TicketPolicyGather/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/jws/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/sms/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/utility/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/workflow/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/underwrite/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/student_sz/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/rescue/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/register/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/receiver/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/newCard/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/mobile/src/main" "client/EbsWeb/WEB-INF/classes" 
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/ca/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/osaccaconfig/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/endorse/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/dispatch_virtual/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/virtualPolicy/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/ebsService/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/complaint/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/flightPolicy/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/dispatch_flight/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/virtualPolicy/src/main" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/cardWebservice" "client/EbsWeb/WEB-INF/classes"
cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "server/hotelUnsubscribe/src/main" "client/EbsWeb/WEB-INF/classes"


cscript replace.vbs "%upgrade_working_path%\list_EbsWeb.txt" "Added" ""



Rem  --------------2.  ��webapp���棬��jar��---------------------
%disk%
cd %webapps_path%
jar -cvfM %upgrade_working_path%\%module%.rar @%upgrade_working_path%\list_EbsWeb.txt 

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
xcopy  client\*.* %yymm_directory%\%timestamp_directory%\%module%\client\*.* /s
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
rem--------------5. ɾ��update_package\temp�µ�list_EbsWeb�ļ�������rar���ͽ�ѹ��-------------------
cd  %upgrade_working_path%
del %module%.rar
rd /s /q %module%
pause
E:
CD �п���Ƽ��ɷ����޹�˾\�ƶ��ű�����
 move_EbsWeb.bat