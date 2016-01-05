#!/bin/bash

echo "파리새끼시작"
fw_depends java7 maven
echo "메이븐설치완료"
export JAVA_OPTS="-Xms2g -Xmx2g -XX:MaxPermSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=25 -verbosegc -Xloggc:/tmp/wildfly_gc.log"
echo "메이븐 이니셜"
mvn clean initialize package -Pbenchmark -Ddatabase.host=${DBHOST}
echo "=========== 특별출현 ==========="
#ls -al

echo "=========== 포트정검 ==========="
sudo fuser -k 9990/tcp &
sudo fuser -k 8009/tcp &
sudo fuser -k 8080/tcp &
sudo fuser -k 8443/tcp &
sudo fuser -k 9993/tcp &

target/wildfly-9.0.1.Final/bin/standalone.sh -b 0.0.0.0 &

echo "파리새끼 완료!"