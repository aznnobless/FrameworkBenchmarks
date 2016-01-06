#!/bin/bash

fw_depends java7 maven
export JAVA_OPTS=" -Djava.net.preferIPv4Stack=true -Xms2g -Xmx2g -XX:MaxPermSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=25 -verbosegc -Xloggc:/tmp/wildfly_gc.log"
mvn clean initialize package -Pbenchmark -Ddatabase.host=${DBHOST}

# echo "=========== 포트정검 ==========="
# sudo fuser -k 9990/tcp &
# sudo fuser -n tcp -k 8009 &
# sudo fuser -n tcp -k 8080 &
# sudo fuser -k 8443/tcp &
# sudo fuser -k 9993/tcp &

# echo "======== 삽질 ======" 
# #ping 0.0.0.0:8080
# echo "========   ========"

target/wildfly-9.0.1.Final/bin/standalone.sh -b 0.0.0.0 &

