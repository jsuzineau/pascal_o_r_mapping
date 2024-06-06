set Path=%PATH%;C:\lamw_manager\LAMW\sdk\platform-tools
set GRADLE_HOME=C:\lamw_manager\LAMW\gradle-8.8\
set PATH=%PATH%;%GRADLE_HOME%\bin
gradle clean bundle --info
