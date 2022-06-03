export PATH=/lamw_manager/LAMW/apache-ant-1.10.5/bin:$PATH
export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /01_Projets/01_pascal_o_r_mapping/tools/lamw/jsNote/
ant -Dtouchtest.enabled=true debug
