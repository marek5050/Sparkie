#!/bin/bash

export HADOOP_CONF_DIR=/etc/hadoop/conf
export SPARK_HOME=/home/jliang/Desktop/spark
TEST=$1
ATTEMPT=$2

INPUT=enwiki-latest-pages-meta-current1.xml
OUTPUT=out/$TEST-$ATTEMPT-$INPUT
if [ $3 != "a" ] 
then   INPUT=$3;
fi 



spark-submit  --master yarn-client ./spark.py ./data/$INPUT $OUTPUT
#spark-submit  --master yarn-client ./spark.py ${DIR}${FILES[1]} output_spark_${FILES[1]}

#HADOOP_CONF_DIR=/etc/hadoop/conf spark-submit --master yarn-client
# ./spark.py book.txt output_book

