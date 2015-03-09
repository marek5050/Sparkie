#!/bin/bash
export HADOOP_HOME=/usr/lib/hadoop
export HADOOP_BIN=/usr/lib/hadoop/bin
export HADOOP_CONF_DIR=/etc/hadoop/conf
export RHIPE_HADOOP_TMP_FOLDER=/user/dotcz12/tmp
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64

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

wget http://ml.stat.purdue.edu/rhipebin/Rhipe_0.75.0_cdh5mr2.tar.gz
R CMD INSTALL Rhipe_0.75.0_cdh5mr2.tar.gz 
