set Path=%PATH%;C:\Users\root\LAMW\apache-ant-1.10.5\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
cd E:\01_Projets\01_pascal_o_r_mapping\jsWorks\android_lamw\jsWorks\
call ant clean release
if errorlevel 1 pause
