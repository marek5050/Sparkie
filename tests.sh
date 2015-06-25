#!/bin/bash

TYPE=$1
IDX=$2
MAPPER=$3
REDUCER=$4

if [ "$IDX" == "" ]
then 
  IDX=3
fi

FILES[0]=book10.txt
FILES[1]=book100.txt
FILES[2]=book100.txt.gz
FILES[3]=book1000.txt
FILES[4]=book10000.txt
FILES[5]=enwiki-latest-stub-articles8.xml #64mb
FILES[6]=enwiki-latest-abstract1.xml  #700mb
FILES[7]=enwiki-latest-pages-meta-current20.xml #4.4GB
FILES[8]=enwiki-latest-pages-articles.xml #48GB
FILES[9]=enwiki-latest-stub-meta-history.xml #262GB

CUR=$(pwd )/
RESULTDIR=$CUR/results
TESTFILE=${FILES[$IDX]}
ATT=1

if [ "$MAPPER" == "" ]
 then 
  MAPPER=5
fi

if [ "$REDUCER" == "" ]
then
  REDUCER=5
fi

if [ "$TYPE" == "all" -o  "$TYPE" == "java" ] 
then
  cd $CUR/Java
  echo "------- JAVA $IDX --------" >> $RESULTDIR/java_$TESTFILE
  time ./test.sh java $IDX  $TESTFILE $MAPPER $REDUCER 2>&1 >> $RESULTDIR/java_$TESTFILE
fi

if [ "$TYPE" == "all" -o  "$TYPE" == "spark" ] 
then
  cd $CUR/Spark
  echo "--------Spark $IDX --------" >> $RESULTDIR/spark_$TESTFILE
  time ./test.sh spark $IDX $TESTFILE $MAPPER $REDUCER 2>&1 >> $RESULTDIR/spark_$TESTFILE
fi

#if [ "$TYPE" == "all" -o  "$TYPE" == "sparkr" ] 
if [ "$TYPE" == "sparkr" ] 
then
    cd $CUR/SparkR
  echo "--------SparkR $IDX--------" >> $RESULTDIR/sparkr_$TESTFILE
   time ./test.sh sparkR $IDX $TESTFILE $MAPPER $REDUCER 2>&1 >> $RESULTDIR/sparkr_$TESTFILE
fi

  if [ "$TYPE" == "rhipe" ] 
  then
    cd $CUR/RHIPE
    echo "-------RHIPE $IDX--------" >> $RESULTDIR/rhipe_$TESTFILE
    time ./test.sh rhipe $IDX $TESTFILE $MAPPER $REDUCER # 2>&1 >> $RESULTDIR/rhipe_$TESTFILE 
  fi

if [ "$TYPE" == "all" -o "$TYPE" == "streaming" ]
then
 cd $CUR/Streaming 
 echo "--------Streaming $IDX--------"  >> $RESULTDIR/streaming_$TESTFILE
 echo "-----------PYTHON--------" >> $RESULTDIR/streaming_$TESTFILE
 time ./test.sh py $IDX $TESTFILE $MAPPER $REDUCER  2>&1 >> $RESULTDIR/streaming_$TESTFILE
 echo "-----------R--------" >> $RESULTDIR/streaming_$TESTFILE
 time ./test.sh r $IDX $TESTFILE $MAPPER $REDUCER  2>&1 >> $RESULTDIR/streaming_$TESTFILE
fi
