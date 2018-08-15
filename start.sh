#!/bin/bash
source /usr/src/myapp/libs.sh

ls -l /opt

ls -l /usr/src/myapp/

echo ZOOKEEPER_VERSION=$ZOOKEEPER_VERSION

#exit

mkdir $ZOOKEEPER_DATADIR -p

#sed -i -e 's|dataDir=/tmp/zookeeper|dataDir='$ZOOKEEPER_DATADIR'|g' /opt/kafka_2.12-1.1.0/config/zookeeper.properties

echo "dataDir=$ZOOKEEPER_DATADIR" >> $CONFIG
echo "dataLogDir=$ZOOKEEPER_LOGDIR" >> "$CONFIG"


processZOOKEEPER_NODES

#/opt/kafka_2.12-1.1.0/bin/zookeeper-server-start.sh /opt/kafka_2.12-1.1.0/config/zookeeper.properties 
#/opt/kafka_2.12-1.1.0/bin/kafka-server-start.sh /opt/kafka_2.12-1.1.0/config/server.properties

cd /opt/zookeeper/
bin/zkServer.sh start-foreground

sleep 3000