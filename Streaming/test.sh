#!/bin/bash
#locate hadoop | grep streaming | grep jar
#HADOOP_STREAMING_JAR = /usr/lib/hadoop-mapreduce/hadoop-streaming.jar

TEST=$1
ATTEMPT=$2
INPUT=$3
MAPPER_COUNT=$4 
REDUCER_COUNT=$5 

DIR=/user/$(whoami)


if [ "$1"  == "" ]
then 
   TEST=r
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
 

OUTPUT=out/streaming-$TEST-$ATTEMPT-$INPUT

#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input ${FILES[0]} -output ./output-${FILES[0]}
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input book.txt -output ./output-bookies
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input book.txt -output ./output-bookies2


# echo $TEST
# echo "INPUT: " $INPUT
# echo "OUTPUT: " $OUTPUT

if [ "$TEST" == "r" ] 
then 
MAPPER=mapper.R
REDUCER=reducer.R
fi

if [ "$TEST" == "py" ] 
then 
MAPPER=mapper.py
REDUCER=reducer.py
fi


hdfs dfs -rm -r -f $OUTPUT

echo $MAPPER_COUNT $REDUCER_COUNT
echo $TEST $INPUT $MAPPER $REDUCER

hadoop jar ${HADOOP_STREAMING_JAR} \
-Dmapreduce.job.name="$TEST-$MAPPER_COUNT-$REDUCER_COUNT-$INPUT" \
-Dmapreduce.job.maps=$MAPPER_COUNT \
-Dmapreduce.job.reduces=$REDUCER_COUNT \
-Dmapreduce.map.java.opts=-Xmx12000M \
-Dmapreduce.reduce.java.opts=-Xmx12000M \
 -files ./$MAPPER,./$REDUCER -mapper ./$MAPPER  -reducer ./$REDUCER -input ./data/$INPUT -output ./$OUTPUT

#-Dmapreduce.task.profile=true \
#-Dmapreduce.task.profile.maps=0-2 \
#-Dmapreduce.task.profile.reduces=0-1 \
#-Dmapred.task.profile=true \
#-Dmapreduce.map.java.opts=-Xmx400M
#-Dmapreduce.reduce.java.opts=-Xmx400M
#
#-Dmapreduce.job.maps=10 \
#-Dmapred.job.reduces=10\
#-Dmapreduce.tasktracker.map.tasks.maximum=100000\
#-Dmapreduce.tasktracker.reduce.tasks.maximum=100\


#if [$TEST =="python"] then
#hdfs dfs -rm -r -f ./out/PY_${FILES[0]}
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input ${FILES[0]} -output ./out/PY_${FILES[0]}
