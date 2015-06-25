#!/bin/bash
export HADOOP_HOME=/usr/lib/hadoop
export HADOOP_BIN=/usr/lib/hadoop/bin
export HADOOP_CONF_DIR=/etc/hadoop/conf
export RHIPE_HADOOP_TMP_FOLDER=/user/$(whoami)/tmp
export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
export HADOOP_LIBS=/usr/lib/hadoop/client:/usr/lib/hadoop/lib:/usr/lib/hadoop:/usr/lib/hadoop-hdfs:/usr/lib/hadoop-yarn:/usr/lib/hadoop-mapreduce
CUR_DIR=$(pwd)

## CONFIGURE R SHARED LIBR
if [ "$R_LIBS" = "" ] 
then 
  mkdir -p $CUR_DIR/R_libs
  export R_LIBS=$CUR_DIR"/R_libs"

fi

RPATH=$CUR_DIR/R
RVERSION=3.1.2

if [ "$1" == "R" -o "$1" == "" ] 
then

### INSTALL R
wget http://cran.r-project.org/src/base/R-3/R-$RVERSION.tar.gz
tar -xzf R-$RVERSION.tar.gz
cd R-$RVERSION
# need to build shared library (--enable-R-shlib)
./configure --enable-R-shlib  --prefix=$RPATH --with-x=no
make
make install

echo $PATH
cd ..
rm -r R-$RVERSION
fi

export LD_LIBRARY_PATH=$RPATH/lib64/R/lib:$LD_LIBRARY_PATH
export PATH=$RPATH/bin:$PATH
echo $PATH


## CREATE HDFS TMP DIR
#hdfs dfs -mkdir $RHIPE_HADOOP_TMP_FOLDER

##INSTALL PROTOBUF
PROTO_BUF_VERSION=2.5.0
INSTALL_DIR=$CUR_DIR/protobuf$PROTO_BUF_VERSION
export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INSTALL_DIR/lib


if [ "$1" == "PROTO" -o "$1" == ""  ]
then
mkdir $INSTALL_DIR

wget https://protobuf.googlecode.com/files/protobuf-$PROTO_BUF_VERSION.tar.bz2
tar jxvf protobuf-$PROTO_BUF_VERSION.tar.bz2
cd protobuf-$PROTO_BUF_VERSION
./configure --prefix=$INSTALL_DIR && make -j4
make install
cd ..

fi

if [ "$1" == "RHIPE" -o "$1" == "" ]
then
wget http://cran.r-project.org/src/contrib/rJava_0.9-6.tar.gz
R CMD INSTALL rJava_0.9-6.tar.gz

R CMD javareconf -e 

wget http://ml.stat.purdue.edu/rhipebin/Rhipe_0.75.0_cdh5mr2.tar.gz
R CMD INSTALL Rhipe_0.75.0_cdh5mr2.tar.gz 

fi

if [ "$1" == "script" -o "$1" == "" ]
then 
SCRIPT="export HADOOP_HOME=$HADOOP_HOME \n
export HADOOP_BIN=$HADOOP_BIN \n
export HADOOP_CONF_DIR=$HADOOP_CONF_DIR  \n
export HADOOP_LIBS=$HADOOP_LIBS\n
export RHIPE_HADOOP_TMP_FOLDER=$RHIPE_HADOOP_TMP_FOLDER \n
export JAVA_HOME=$JAVA_HOME  \n
export R_LIBS=$R_LIBS  \n
export PATH=$PATH \n
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH  \n
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH \n"
echo -e $SCRIPT > env.sh
chmod +x env.sh

fi
