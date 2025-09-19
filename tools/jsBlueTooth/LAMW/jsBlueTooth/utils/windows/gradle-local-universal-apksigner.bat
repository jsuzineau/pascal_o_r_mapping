set Path=%PATH%;C:\lamw_manager\LAMW\sdk\platform-tools;C:\lamw_manager\LAMW\sdk\build-tools\30.0.3
set GRADLE_HOME=C:\lamw_manager\LAMW\gradle-8.8
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\build\outputs\apk\release\jsBlueTooth-universal-release-unsigned.apk E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\build\outputs\apk\release\jsBlueTooth-universal-release-unsigned-aligned.apk
apksigner sign --ks E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\jsbluetooth-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\build\outputs\apk\release\jsBlueTooth-release.apk E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\build\outputs\apk\release\jsBlueTooth-universal-release-unsigned-aligned.apk
