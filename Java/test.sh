#!/bin/bash
TEST=$1
ATTEMPT=$2
INPUT=$3
MAPPER_COUNT=$4 
REDUCER_COUNT=$5 

DIR=/user/$(whoami)



if [ "$1"  == "" ]
then 
   TEST=java
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

hdfs dfs -rm -r -f $OUTPUT;

hadoop jar wordcount.jar -m $MAPPER_COUNT -r $REDUCER_COUNT hdfs:///user/dotcz12/data/$INPUT $OUTPUT

#SPARKR_USE_SPARK_SUBMIT=1 YARN_CONF_DIR=/etc/hadoop/conf ./SparkR-pkg-master/sparkR wordcount.R yarn-client ${FILES[0]} $OUTPUT

#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input ${FILES[0]} -output ./out/R_${FILES[0]}_
#$ATTEMPT;

#fi
