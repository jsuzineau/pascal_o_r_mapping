set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_151
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer
keytool -genkey -v -keystore ams_spectrometer-release.keystore -alias ams_spectrometer.keyalias -keyalg RSA -keysize 2048 -validity 10000 < E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer\keytool_input.txt
