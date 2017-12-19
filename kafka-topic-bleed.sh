#!/bin/bash -e

while getopts ":s:i:e:m:u:p:a:c:h" arg
do
  case "$arg" in
    t)
      topic=$OPTARG       # 'admin'
    ;;
    z)
      zookeeper_url=$OPTARG   # 'http://chs-alphakey-pp.internal.ch'
    ;;
    r)
      retention=$OPTARG    # 'true'
    ;;
    w)
      wait=$OPTARG    # 'true'
    ;;
    h)
      echo ""
      echo "Kafka bleed Script"
      echo ""
      echo " * Empties kafka topics of message"
      echo ""
      echo "Options are:"
      echo ""
      echo "      OPTION    ENV-VAR        DESCRIPTION                                                           EXAMPLE ('' does NOT indicate default value)"
      echo "        -t      topic          A kafka topic you want emptied.                                       import-observations-extracted"
      echo "        -z      zookeeper_url  The zookeeper url, defaults to                                        localhost:2181"
      echo "        -r      retention      The new retention of topic in secs, defaults to                       86400000"
      echo "        -w      wait           The time to wait between changing the retention in secs, defaults to  60"
      echo ""
      exit 0
    ;;
    \?)
      echo "ERROR: Unknown option $OPTARG"
    ;;
  esac
done

topics=('testing')
if [ -n "$topic" ]; then
    echo "new topic: $topic"
    topics=("${topics[@]}" $topic)
fi

echo "The following kafka topics are going to be bled:"
echo ""

for i in "${topics[@]}"
do
    :
    echo "$i"
done

echo ""
# Set default retention
if [  -z "$retention" ]; then
    retention=86400000
fi
echo "retention is set to: $retention"

echo ""
# Set default zookeeper_url
if [  -z "$zookeeper_url" ]; then
    zookeeper_url="localhost:2181"
fi
echo "zookeeper url is set to: $zookeeper_url"

echo ""
# Set default retention
if [  -z "$wait" ]; then
    wait=60
fi
echo "wait between changing retention times is: $wait"

echo "-----------------------------------"
echo "STEP 1: Lower retention of kafka topics"
echo ""
for i in "${topics[@]}"
do
    :
    bleed_topic="/usr/local/Cellar/kafka/0.10.2.0/bin/kafka-topics --zookeeper $zookeeper_url --alter --topic $i --config retention.ms=1000"
    echo $bleed_topic
    eval $bleed_topic
    echo "bleeding topic: $i"
done

echo "-----------------------------------"
echo "STEP 2: Sleep for $wait seconds whilst topics bleed"
sleep $wait
echo "successfully bled topics"
echo ""

echo "-----------------------------------"
echo "STEP 3: Raise retention of kafka topics to $retention"
echo ""
for i in "${topics[@]}"
do
    :
    conf_topic="/usr/local/Cellar/kafka/0.10.2.0/bin/kafka-topics --zookeeper $zookeeper_url --alter --topic $i --config retention.ms=$retention"
    echo $conf_topic
    eval $conf_topic
    echo "configured retention of topic: $i"
done
echo "-----------------------------------"
echo ""
echo "Cleared out kafka topics"
