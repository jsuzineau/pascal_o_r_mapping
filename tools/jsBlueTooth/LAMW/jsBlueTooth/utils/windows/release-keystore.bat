set JAVA_HOME=C:\lamw_manager\LAMW\jdk\zulu-default
set PATH=%JAVA_HOME%\bin;%PATH%
set JAVA_TOOL_OPTIONS=-Duser.language=en
cd E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth
keytool -genkey -v -keystore jsbluetooth-release.keystore -alias jsbluetooth.keyalias -keyalg RSA -keysize 2048 -validity 10000 < E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\keytool_input.txt
:Error
echo off
cls
echo.
echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.
echo.
pause
