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
process_param_config

echo replacing {HOSTNAME_FQDN} with $HOSTNAME_FQDN
cp $JAAS_FILE_LOCATION_RO $JAAS_FILE_LOCATION
sed -i -e 's/{HOSTNAME_FQDN}/'"$HOSTNAME_FQDN"'/g' $JAAS_FILE_LOCATION
cat $JAAS_FILE_LOCATION

echo "Configuration"
cat $CONFIG


cd /opt/zookeeper/
bin/zkServer.sh start-foreground

#sleep 30000