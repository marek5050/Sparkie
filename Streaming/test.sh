
#locate hadoop | grep streaming | grep jar
#HADOOP_STREAMING_JAR = /usr/lib/hadoop-mapreduce/hadoop-streaming.jar

TESTFILES=7
DIR=hdfs:///user/dotcz12/
FILES[0]=enwiki-latest-stub-articles8.xml

hdfs dfs -rm -r -f output-${FILES[0]}
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input ${FILES[0]} -output ./output-${FILES[0]}
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.R,./reducer.R -mapper ./mapper.R  -reducer ./reducer.R -input book.txt -output ./output-bookies
#hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input book.txt -output ./output-bookies2
hadoop jar ${HADOOP_STREAMING_JAR} -files ./mapper.py,./reducer.py -mapper ./mapper.py  -reducer ./reducer.py -input ${FILES[0]} -output ./output-bookies222
