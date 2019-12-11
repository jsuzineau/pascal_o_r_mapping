export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /01_Projets/01_pascal_o_r_mapping/electronic/Arduino/AMS_Spectrometer/lamw/AMS_Spectrometer
keytool -genkey -v -keystore ams_spectrometer-release.keystore -alias ams_spectrometer.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /01_Projets/01_pascal_o_r_mapping/electronic/Arduino/AMS_Spectrometer/lamw/AMS_Spectrometer/keytool_input.txt
