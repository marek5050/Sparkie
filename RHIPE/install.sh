#!/bin/bash
export HADOOP_HOME=/usr/lib/hadoop
export HADOOP_BIN=/usr/lib/hadoop/bin
export HADOOP_CONF_DIR=/etc/hadoop/conf
export RHIPE_HADOOP_TMP_FOLDER=/user/dotcz12/tmp
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
export HADOOP_LIBS=/usr/lib/hadoop/client:/usr/lib/hadoop/lib:/usr/lib/hadoop:/usr/lib/hadoop-hdfs:/usr/lib/hadoop-yarn:/usr/lib/hadoop-mapreduce
CUR_DIR=$(pwd)

## CONFIGURE R SHARED LIBR
if [ "$R_LIBS" = "" ] 
then 
  mkdir -p $CUR_DIR/R_libs
  export R_LIBS=$CUR_DIR"/R_libs"

fi

##INSTALL PROTOBUF
PROTO_BUF_VERSION=2.5.0
INSTALL_DIR=$CUR_DIR/protobuf$PROTO_BUF_VERSION

mkdir $INSTALL_DIR

export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INSTALL_DIR/lib:/usr/lib64/R/lib

wget https://protobuf.googlecode.com/files/protobuf-$PROTO_BUF_VERSION.tar.bz2
tar jxvf protobuf-$PROTO_BUF_VERSION.tar.bz2
cd protobuf-$PROTO_BUF_VERSION
./configure --prefix=$INSTALL_DIR && make -j4
make install

cd ..
wget http://ml.stat.purdue.edu/rhipebin/Rhipe_0.75.0_cdh5mr2.tar.gz
R CMD INSTALL Rhipe_0.75.0_cdh5mr2.tar.gz 


SCRIPT="export HADOOP_HOME=$HADOOP_HOME \n
export HADOOP_BIN=$HADOOP_BIN \n
export HADOOP_CONF_DIR=$HADOOP_CONF_DIR  \n
export HADOOP_LIBS=$HADOOP_LIBS\n
export RHIPE_HADOOP_TMP_FOLDER=$RHIPE_HADOOP_TMP_FOLDER \n
export JAVA_HOME=$JAVA_HOME  \n
export R_LIBS=$R_LIBS  \n
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH  \n
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH \n"
echo -e $SCRIPT > env.sh

chmod +x env.sh
