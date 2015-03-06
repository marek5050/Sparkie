#!/bin/bash

export HADOOP_CONF_DIR=/etc/hadoop/conf
export SPARK_HOME=/home/jliang/Desktop/spark

TESTFILES=7

DIR=hdfs:///user/dotcz12/

FILES[0]=enwiki-latest-stub-articles8.xml 
FILES[1]=enwiki-latest-abstract1.xml
FILES[2]=enwiki-latest-all-titles
FILES[3]=enwiki-latest-stub-meta-current1.xml
FILES[4]=enwiki-latest-pages-meta-current1.xml

spark-submit  --master yarn-client ./spark.py ${DIR}${FILES[0]} output_spark_${FILES[0]}
spark-submit  --master yarn-client ./spark.py ${DIR}${FILES[1]} output_spark_${FILES[1]}

spark-submit  --master yarn-client ./spark.py ${DIR}${FILES[2]} output_spark_${FILES[2]}
spark-submit  --master yarn-client ./spark.py ${DIR}${FILES[3]} output_spark_${FILES[3]}


#HADOOP_CONF_DIR=/etc/hadoop/conf spark-submit --master yarn-client
# ./spark.py book.txt output_book

