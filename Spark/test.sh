#!/bin/bash
# export HADOOP_CONF_DIR=/etc/hadoop/conf
# export SPARK_HOME=/home/jliang/Desktop/spark

TEST=$1
ATTEMPT=$2
INPUT=$3
MAPPER_COUNT=$4 
REDUCER_COUNT=$5 

DIR=/user/$(whoami)

if [ "$1"  == "" ]
then 
   TEST=spark
fi

if [ "$2" == "" ]
then
	ATTEMPT=1
fi

if [ "$3" == "" ] 
then
   INPUT=enwiki-latest-pages-meta-current1.xml
fi 

if [ "$4" == "" ] 
then 
  MAPPER_COUNT=10
fi

if [ "$5" == "" ] 
then 
   REDUCER_COUNT=10
fi

OUTPUT=out/$TEST-$ATTEMPT-$INPUT

spark-submit  --master yarn-client spark.py "$TEST-$ATTEMPT-$INPUT" data/$INPUT $OUTPUT
#spark-submit  --master yarn-client ./spark.py ${DIR}${FILES[1]} output_spark_${FILES[1]}

#HADOOP_CONF_DIR=/etc/hadoop/conf spark-submit --master yarn-client
# ./spark.py book.txt output_book
