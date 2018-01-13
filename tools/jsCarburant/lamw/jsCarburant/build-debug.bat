set Path=%PATH%;C:\lamw\apache-ant-1.9.6\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_131
cd C:\_freepascal\pascal_o_r_mapping\tools\jsCarburant\lamw\jsCarburant
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
