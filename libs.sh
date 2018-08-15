
processZOOKEEPER_NODES(){

nodes=$(echo $ZOOKEEPER_NODES | tr ";" "\n")

HOSTNAME=`hostname -f`
#HOSTNAME=mainserver

echo HOSTNAME=[$HOSTNAME]

echo listing nodes

for addr in $nodes
do

	echo node:            $addr
	
	INDEXWITHSERVER=`echo $addr | cut -d ":" -f 1`
	echo INDEXWITHSERVER:            $INDEXWITHSERVER
	INDEX=`echo $INDEXWITHSERVER | cut -d "=" -f 1| cut -d "." -f 2`
	echo INDEX:            $INDEX

	SERVER=`echo $INDEXWITHSERVER | cut -d "=" -f 2 | cut -d ":" -f 1`
	echo SERVER:[$SERVER]

if [ "$SERVER" == "$HOSTNAME" ]; then
    echo "Strings match"

		echo "found server index > $INDEX "
		echo $INDEX >> $ZOOKEEPER_DATADIR/myid #Add Server ID for Respective Instances i.e. "server.1, server.2 and server.3"
fi
	
    echo "$addr" >> /opt/zookeeper/conf/zoo.cfg
done

#echo "server.1=mainserver:2888:3888" >> /opt/kafka_2.12-1.1.0/config/zookeeper.properties
#server.2=node2.thegeekstuff.com:2888:3888
#server.3=node3.thegeekstuff.com:2888:3888

}
