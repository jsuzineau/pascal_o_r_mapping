export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd E:\01_Projets\01_pascal_o_r_mapping\tools\jsBlueTooth\LAMW\jsBlueTooth\utils\unix\
keytool -genkey -v -keystore jsbluetooth-release.keystore -alias jsbluetooth.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/keytool_input.txt
