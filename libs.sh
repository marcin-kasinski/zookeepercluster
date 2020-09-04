
processZOOKEEPER_NODES(){

ZOOKEEPER_NODES=${ZOOKEEPER_NODES//\{HOSTNAME_FQDN\}/$HOSTNAME_FQDN}

nodes=$(echo $ZOOKEEPER_NODES | tr "," "\n")

echo HOSTNAME_FQDN=[$HOSTNAME_FQDN]

echo listing nodes

INDEX=1;

for SERVER in $nodes
do

	echo node:            $addr
	
	#INDEXWITHSERVER=`echo $addr | cut -d ":" -f 1`
	#echo INDEXWITHSERVER:            $INDEXWITHSERVER
	#INDEX=`echo $INDEXWITHSERVER | cut -d "=" -f 1| cut -d "." -f 2`
	#echo INDEX:            $INDEX

	SERVER_WITHOUT_PORTS=`echo $SERVER | cut -d ":" -f 1`
	#echo SERVER:[$SERVER]
    echo server :$SERVER index $INDEX

    if [ "$SERVER_WITHOUT_PORTS" == "$HOSTNAME_FQDN" ]; then
          echo "Strings match $SERVER $INDEX"

      	  echo "found server in env  $SERVER $INDEX"
          echo $INDEX >> $ZOOKEEPER_DATADIR/myid
    fi

#if [ "$SERVER" == "$HOSTNAME_FQDN" ]; then
#    echo "Strings match"
#
#		echo "found server index > $INDEX "
#		echo $INDEX >> $ZOOKEEPER_DATADIR/myid #Add Server ID for Respective Instances i.e. "server.1, server.2 and server.3"
#fi
	
    echo "server.$INDEX=$SERVER" >> $CONFIG

	INDEX=$((INDEX + 1))

done

}

param_prefix="ZOOKEEPER_PARAM_"

add_param_to_config()
{
local key=$1
local value=$2

#remove prefix
key=${key#"$param_prefix"}
#replace _ with .
key=${key//[_]/.}
#lowercase
#key=${key,,}

echo "adding line to config key ["$key"] value ["$value"]"
echo "$key=$value" >> $CONFIG
}

process_param_config()
{

echo "process_param_config()"

for line in $(set); do
	KEY=`echo $line | cut -d "=" -f 1`
	#echo "KEY $KEY"
	#get only value
	VALUE=`echo "$line" | cut -d'=' -f2-`
	#echo "VALUE $VALUE"
	# replace {HOSTNAME_FQDN}
    #VALUE=${VALUE//[\%HOSTNAME\%]/$HOSTNAME}
    VALUE=${VALUE//\{HOSTNAME_FQDN\}/$HOSTNAME_FQDN}
    VALUE=${VALUE//\{HOSTNAME\}/$HOSTNAME}
    #VALUE=${VALUE//'}
    #remove '
    #VALUE=${VALUE//'}
	#echo "VALUE $VALUE"

	VALUE=`echo "$VALUE" | cut -d "'" -f 2`

	[[ $KEY =~ ^"$param_prefix" ]] && add_param_to_config $KEY $VALUE
	
done

}
