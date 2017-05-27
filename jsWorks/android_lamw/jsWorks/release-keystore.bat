set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_131
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd C:\_freepascal\pascal_o_r_mapping\jsWorks\android_lamw\jsWorks
keytool -genkey -v -keystore jsWorks-release.keystore -alias jsworksaliaskey -keyalg RSA -keysize 2048 -validity 10000 < C:\_freepascal\pascal_o_r_mapping\jsWorks\android_lamw\jsWorks\keytool_input.txt
