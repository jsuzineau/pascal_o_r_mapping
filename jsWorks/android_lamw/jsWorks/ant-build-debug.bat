set Path=%PATH%;C:\lamw_manager\LAMW\apache-ant-1.10.5\bin
set JAVA_HOME=C:\lamw_manager\LAMW\jdk\zulu-8
cd E:\01_Projets\01_pascal_o_r_mapping\jsWorks\android_lamw\jsWorks\
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
