
echo "Now start the services needed for spark + kafka. " 

## Step 1: open a tmux window to run the zookeeper service
workloc="/opt/module/kafka/kafka_2.13-3.7.0"
$workloc/bin/zookeeper-server-start.sh $workloc/config/zookeeper.properties

## Step 2: open another tmux window to run the kafka service
workloc="/opt/module/kafka/kafka_2.13-3.7.0"
$workloc/bin/kafka-server-start.sh $workloc/config/server.properties
# $workloc/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
