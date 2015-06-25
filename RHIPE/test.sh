#!/bin/bash
#locate hadoop | grep streaming | grep jar
#HADOOP_STREAMING_JAR = /usr/lib/hadoop-mapreduce/hadoop-streaming.jar

TEST=$1
ATTEMPT=$2
INPUT=$3
MAPPER_COUNT=$4 
REDUCER_COUNT=$5 

DIR=/user/$(whoami)


if [ "$1" == "" ]
then 
   TEST=rhipe
fi

if [ "$2" == "" ]
then 
   ATTEMPT=1
fi

if [ "$4" == "" ] 
then 
  MAPPER_COUNT=10
fi

if [ "$5" == "" ] 
then 
   REDUCER_COUNT=10
fi
 

if [ "$3" == "" ] 
then
   INPUT=enwiki-latest-pages-meta-current1.xml
fi 

OUTPUT=out/$TEST-$ATTEMPT-$INPUT

hdfs dfs -rm -r -f $OUTPUT

./wordcount.sh $ATTEMPT $INPUT $MAPPER_COUNT $REDUCER_COUNT
