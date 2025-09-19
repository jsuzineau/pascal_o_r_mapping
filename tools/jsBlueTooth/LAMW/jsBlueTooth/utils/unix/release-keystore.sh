export JAVA_HOME=/lamw_manager/LAMW/jdk/zulu-default
cd /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth
LC_ALL=C keytool -genkey -v -keystore jsbluetooth-release.keystore -alias jsbluetooth.keyalias -keyalg RSA -keysize 2048 -validity 10000 < /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/keytool_input.txt
