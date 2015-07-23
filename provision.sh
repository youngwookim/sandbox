## for unbuffered output log of ansible-playbook
export PYTHONUNBUFFERED=1

## RepoForge(rpmforge)
#rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

## Git
#yum install -y --enablerepo=rpmforge-extras git

yum install -y java-1.7.0-openjdk-devel snappy snappy-devel wget make rpm-build fuse-devel cmake fuse-libs redhat-rpm-config lzo-devel autoconf automake redhat-lsb nc createrepo asciidoc python-devel python-setuptools libxml2-devel libxslt-devel cyrus-sasl-devel openldap-devel mysql-devel xmlto nodejs npm 

#cd ~ && git clone https://github.com/apache/bigtop.git
#cd bigtop && ./gradlew toolchain

# Install packages
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` zlib-devel openssl-devel perl wget sudo rsync ntp ntpdate bzip2 unzip sudo vim

cp /vagrant/confs/yum/bigtop.repo /etc/yum.repos.d/bigtop.repo
cp /vagrant/confs/yum/epel.repo /etc/yum.repos.d/epel.repo
cp /vagrant/confs/yum/pgdg-94-centos.repo /etc/yum.repos.d/pgdg-94-centos.repo

source /etc/profile

# Zookeeper
yum install -y zookeeper*
echo "server.1=host1.sandbox.com:2888:3888" >> /etc/zookeeper/conf/zoo.cfg
echo "1" > /var/lib/zookeeper/myid
service zookeeper-server start
service zookeeper-rest start

# Hadoop
yum install -y hadoop-hdfs-namenode
cp /vagrant/confs/hadoop/conf/core-site.xml /etc/hadoop/conf/core-site.xml
cp /vagrant/confs/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
cp /vagrant/confs/hadoop/conf/hadoop-env.sh /etc/hadoop/conf/hadoop-env.sh

mkdir -p /data1/hadoop/hdfs/data
chown -R hdfs:hdfs /data1/hadoop/hdfs

/etc/init.d/hadoop-hdfs-namenode init
service hadoop-hdfs-namenode start
/usr/lib/hadoop/libexec/init-hdfs.sh

yum install -y hadoop-hdfs-datanode hadoop-yarn-nodemanager hadoop-mapreduce
cp /vagrant/confs/hadoop/conf/slaves /etc/hadoop/conf/slaves
service hadoop-hdfs-datanode start

yum install -y hadoop-mapreduce-historyserver
cp /vagrant/confs/hadoop/conf/mapred-site.xml /etc/hadoop/conf/mapred-site.xml
service hadoop-mapreduce-historyserver start

yum install -y hadoop-yarn-resourcemanager 
cp /vagrant/confs/hadoop/conf/yarn-site.xml /etc/hadoop/conf/yarn-site.xml
mkdir -p /data1/hadoop/yarn/local
chown -R yarn:yarn /data1/hadoop/yarn
service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start

# Tez
yum install -y tez

cp /vagrant/confs/hadoop/conf/tez-hadoop-env.sh /etc/hadoop/conf/hadoop-env.sh
cp /vagrant/confs/hadoop/conf/tez-mapred-site.xml /etc/hadoop/conf/mapred-site.xml

sudo -u hdfs hdfs dfs -mkdir -p /apps/tez
sudo -u hdfs hdfs dfs -mkdir -p /apps/tez/lib
sudo -u hdfs hdfs dfs -copyFromLocal  /usr/lib/tez/* /apps/tez
sudo -u hdfs hdfs dfs -copyFromLocal /usr/lib/tez/lib/* /apps/tez/lib

# Hive 
yum install -y hive-metastore
yum install -y hive-server2

cp /vagrant/confs/hive/conf/hive-site.xml /usr/lib/hive/conf/hive-site.xml

sudo -u hdfs hdfs dfs -mkdir /user/hive/warehouse
sudo -u hdfs hdfs dfs -chown hive /user/hive/warehouse
sudo -u hdfs hdfs dfs -chmod 1777 /user/hive/warehouse

# Hive Metastore (PostgreSQL)
yum localinstall -y http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
yum list postgresql94*
yum install -y postgresql94-server
service postgresql-9.4 initdb

cp /vagrant/confs/hive/metastore/postgresql.conf /var/lib/pgsql/9.4/data/postgresql.conf
cp /vagrant/confs/hive/metastore/pg_hba.conf /var/lib/pgsql/9.4/data/pg_hba.conf

chkconfig postgresql-9.4 on
service postgresql-9.4 start

yum install -y postgresql94-jdbc
ln -s /usr/share/java/postgresql94-jdbc.jar /usr/lib/hive/lib/postgresql-jdbc.jar

sudo -u postgres psql -c "CREATE USER hive WITH PASSWORD 'hive';"
sudo -u postgres psql -c "CREATE DATABASE hive;"

/usr/lib/hive/bin/schematool -dbType postgres -initSchemaTo 1.2.0
/usr/lib/hive/bin/schematool -dbType postgres -info

service hive-metastore restart
service hive-server2 restart

# Spark
yum install -y spark-master spark-worker spark-history-server spark-thriftserver

## Create a log directory on HDFS:
su -s /bin/bash hdfs -c '/usr/bin/hadoop fs -mkdir -p /var/log/spark/apps'
su -s /bin/bash hdfs -c '/usr/bin/hadoop fs -chmod -R 1777 /var/log/spark/apps'
su -s /bin/bash hdfs -c '/usr/bin/hadoop fs -chown spark:spark /var/log/spark/apps'

## Edit spark conf & env
cp /vagrant/confs/spark/conf/spark-defaults.conf /usr/lib/spark/conf/spark-defaults.conf
cp /vagrant/confs/spark/conf/spark-env.sh /usr/lib/spark/conf/spark-env.sh

## Run spark:
service spark-master start
service spark-worker start
service spark-history-server start

## setting Hive On Tez
cp /vagrant/confs/hive/conf/HiveOnTez-hive-site.xml /usr/lib/hive/conf/hive-site.xml

## installing & setting hbase 
yum install -y hbase-master
yum install -y hbase-regionserver
yum install -y hbase-thrift
yum install -y hbase-thrift2

cp /vagrant/confs/hbase/conf/hbase-site.xml /etc/hbase/conf/hbase-site.xml
cp /vagrant/confs/hadoop/conf/HBase-hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml

service hbase-master start
service hbase-regionserver start

## HUE
yum install -y hue*

service hue start

# Test
su -s /bin/bash hdfs -c 'yarn jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 5 5'

sudo -u hdfs hdfs dfs -mkdir -p /user/hdfs/testTez/in
sudo -u hdfs hdfs dfs -mkdir -p /user/hdfs/testTez/out
sudo -u hdfs hdfs dfs -copyFromLocal /vagrant/examples/hanja.txt /user/hdfs/testTez/in/
su -s /bin/bash hdfs -c 'hadoop jar  /usr/lib/tez/tez-examples-0.6.0.jar orderedwordcount /user/hdfs/testTez/in/ /user/hdfs/testTez/out/'

spark-submit --class org.apache.spark.examples.SparkPi --deploy-mode cluster --master yarn /usr/lib/spark/lib/spark-examples.jar 2


# Flume, Kafka, Phoenix, Sqoop 1.4.x, Sqoop 1.99.x, Pig, Mahout
yum install -y flume\* kafka\* phoenix\* sqoop\* sqoop2\* pig mahout\*

# Presto
yum install -y java-1.8.0-openjdk-devel presto-server presto-cli presto-jdbc
cp /vagrant/confs/presto/hive.properties /etc/presto/catalog/
service presto-server start

