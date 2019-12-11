set Path=%PATH%;C:\Users\root\LAMW\apache-ant-1.10.5\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
cd E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer
call ant clean -Dtouchtest.enabled=true debug
if errorlevel 1 pause
