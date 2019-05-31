set Path=%PATH%;C:\Users\root\LAMW\apache-ant-1.10.5\bin
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
cd C:\Users\root\LAMW\lazandroidmodulewizard\demos\GUI\AppActionBarTabDemo1\
call ant clean release
if errorlevel 1 pause
