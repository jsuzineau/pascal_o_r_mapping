export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /01_Projets/01_pascal_o_r_mapping/electronic/Arduino/AMS_Spectrometer/lamw/AMS_Spectrometer
jarsigner -verify -verbose -certs /01_Projets/01_pascal_o_r_mapping/electronic/Arduino/AMS_Spectrometer/lamw/AMS_Spectrometer/bin/AMS_Spectrometer-release.apk
