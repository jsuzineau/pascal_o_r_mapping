set Path=%PATH%;C:\Users\root\LAMW\sdk\platform-tools;C:\Users\root\LAMW\sdk\build-tools\26.0.2
set GRADLE_HOME=C:\Users\root\LAMW\gradle-4.4.1
set PATH=%PATH%;%GRADLE_HOME%\bin
zipalign -v -p 4 E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer\build\outputs\apk\release\AMS_Spectrometer-release-unsigned.apk E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer\build\outputs\apk\release\AMS_Spectrometer-release-unsigned-aligned.apk
apksigner sign --ks ams_spectrometer-release.keystore --out E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer\build\outputs\apk\release\AMS_Spectrometer-release.apk E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer\build\outputs\apk\release\AMS_Spectrometer-release-unsigned-aligned.apk
