set Path=%PATH%;C:\lamw_manager\LAMW\apache-ant-1.10.5\bin
set JAVA_HOME=C:\lamw_manager\LAMW\jdk\zulu-default
cd E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\utils\windows\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
