
#locate hadoop | grep streaming | grep jar
#HADOOP_STREAMING_JAR = /usr/lib/hadoop-mapreduce/hadoop-streaming.jar
TEST=$1
ATTEMPT=$2
DIR=/user/$(whoami)

INPUT=enwiki-latest-pages-meta-current1.xml
#if [ $3 != "" ] then
#   INPUT=$3;
#fi 

OUTPUT=out/$TEST-$ATTEMPT-$INPUT

#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input ${FILES[0]} -output ./output-${FILES[0]}
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input book.txt -output ./output-bookies
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input book.txt -output ./output-bookies2


echo $TEST
echo "INPUT: " $INPUT
echo "OUTPUT: " $OUTPUT

if [ $TEST == "r" ] 
then 
hdfs dfs -rm -r -f $OUTPUT;

hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input ./data/$INPUT -output ./$OUTPUT
fi

if [ $TEST == "py" ] 
then echo "123";

hdfs dfs -rm -r -f $OUTPUT;

hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input ./data/$INPUT -output ./$OUTPUT

fi

#if [$TEST =="python"] then
#hdfs dfs -rm -r -f ./out/PY_${FILES[0]}
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input ${FILES[0]} -output ./out/PY_${FILES[0]}


