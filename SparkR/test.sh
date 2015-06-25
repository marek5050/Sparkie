#!/bin/bash
TEST=$1
ATTEMPT=$2
INPUT=$3
MAPPER_COUNT=$4 
REDUCER_COUNT=$5 

DIR=/user/$(whoami)


if [ "$1"  == "" ]
then 
   TEST=sparkr
fi

if [ "$2" == "" ]
then
	ATTEMPT=1
fi

if [ "$3" == "" ] 
then
   INPUT=book10.txt
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


hdfs dfs -rm -r -f $OUTPUT

SPARKR_USE_SPARK_SUBMIT=1 YARN_CONF_DIR=/etc/hadoop/conf MASTER=yarn-client \
SparkR-pkg-master/sparkR wordcount.R yarn-client $TEST-$ATTEMPT-$INPUT /user/dotcz12/data/$INPUT $OUTPUT

#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input ${FILES[0]} -output ./out/R_${FILES[0]}_$ATTEMPT;
#SPARKR_USE_SPARK_SUBMIT=1 YARN_CONF_DIR=/etc/hadoop/conf MASTER=yarn-client SparkR-pkg-master/sparkR wordcount.R yarn-client /user/dotcz12/$INPUT $OUTPUT

#SPARKR_USE_SPARK_SUBMIT=1 YARN_CONF_DIR=/etc/hadoop/conf MASTER=yarn-client SparkR-pkg-master/sparkR wordcount.R yarn-client /user/dotcz12/data/book.txt ./out/wordcount_spar
