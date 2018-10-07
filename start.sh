#!/bin/bash
source /usr/src/myapp/libs.sh

echo ZOOKEEPER_VERSION=$ZOOKEEPER_VERSION

HOSTNAME_FQDN=`hostname -f`

mkdir $ZOOKEEPER_DATADIR -p

#sed -i -e 's|dataDir=/tmp/zookeeper|dataDir='$ZOOKEEPER_DATADIR'|g' /opt/kafka_2.12-1.1.0/config/zookeeper.properties

echo "dataDir=$ZOOKEEPER_DATADIR" >> $CONFIG
echo "dataLogDir=$ZOOKEEPER_LOGDIR" >> "$CONFIG"

#if [ "$AUTH_TYPE" == "SASL_PLAINTEXT" ]; then 
SERVER_JVMFLAGS="$SERVER_JVMFLAGS $EXTRA_JAVA_ARGS
#fi

processZOOKEEPER_NODES
process_param_config

echo replacing {HOSTNAME_FQDN} with $HOSTNAME_FQDN
cp $JAAS_FILE_LOCATION_RO $JAAS_FILE_LOCATION
sed -i -e 's/{HOSTNAME_FQDN}/'"$HOSTNAME_FQDN"'/g' $JAAS_FILE_LOCATION
cat $JAAS_FILE_LOCATION


#change loglevel
sed -i -e 's/=INFO/='"$LOG_LEVEL"'/g' /opt/zookeeper/conf/log4j.properties


echo "Configuration"
cat $CONFIG

echo copy /opt/zookeeper/conf/$HOSTNAME.service.keytab /opt/zookeeper/conf/zk.service.keytab

cp /opt/zookeeper/conf/$HOSTNAME.service.keytab /opt/zookeeper/conf/zk.service.keytab


#tcpdump -i eth0 'port 88' -w /tmp/port.88.debug.txt &
cd /opt/zookeeper/
bin/zkServer.sh start-foreground

#sleep 600000