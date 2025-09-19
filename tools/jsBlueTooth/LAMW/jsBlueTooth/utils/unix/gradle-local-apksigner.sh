export PATH=/lamw_manager/LAMW/sdk/platform-tools:$PATH
export PATH=/lamw_manager/LAMW/sdk/build-tools/30.0.3:$PATH
export GRADLE_HOME=/lamw_manager/LAMW/gradle-8.8
export PATH=$PATH:$GRADLE_HOME/bin
zipalign -v -p 4 /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/build/outputs/apk/release/jsBlueTooth-armeabi-v7a-release-unsigned.apk /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/build/outputs/apk/release/jsBlueTooth-armeabi-v7a-release-unsigned-aligned.apk
apksigner sign --ks /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/jsbluetooth-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/build/outputs/apk/release/jsBlueTooth-release.apk /01_Projets/01_pascal_o_r_mapping/tools/jsBlueTooth/LAMW/jsBlueTooth/build/outputs/apk/release/jsBlueTooth-armeabi-v7a-release-unsigned-aligned.apk
