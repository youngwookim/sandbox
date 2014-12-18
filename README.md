# Sandbox

My Sandbox (CentOS 6.5 x86_64)

Ambari:
```
cd /etc/yum.repos.d/
wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.7.0/ambari.repo

```
```
# yum install ambari-server

# ambari-server setup
```

'Preparing to Install a HDP Cluster', http://docs.hortonworks.com/HDPDocuments/Ambari-1.7.0.0/Ambari_Install_v170/index.html#Item1.1


```
# ambari-server start

```
Open up a web browser and go to http://10.10.10.10:8080.

Log in with username admin and password admin and follow on-screen instructions.



Bigtop:
```
# git clone https://github.com/apache/bigtop.git
# cd bigtop
# gradle yum 

```

Bigtop 0.8 repo (centos6), http://apache.tt.co.kr/bigtop/bigtop-0.8.0/repos/centos6/bigtop.repo
```
# cd /etc/yum.repos.d/
# wget http://apache.tt.co.kr/bigtop/bigtop-0.8.0/repos/centos6/bigtop.repo

```

Bigtop trunk repo, http://14.63.216.163/repo/bigtop/trunk/redhat/6/x86_64/
```
# vi /etc/yum.repos.d/bigtop.repo
[Bigtop]
name=Bigtop
baseurl=http://14.63.216.163/repo/bigtop/trunk/redhat/6/x86_64/
enabled=1
gpgcheck=0

```

MySQL:
```
# MySQL
mv /etc/my.cnf /etc/my.cnf.ORG
cp /vagrant/confs/mysql/my.cnf /etc/my.cnf

service mysqld start

mysqladmin -u root password 'mypassword'

# MySQL user and databases
mysql -uroot -pmypassword -e "CREATE USER 'root'@'localhost' IDENTIFIED BY 'mypassword';"
mysql -uroot -pmypassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
mysql -uroot -pmypassword -e "CREATE USER 'root'@'%' IDENTIFIED BY 'mypassword';"
mysql -uroot -pmypassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -pmypassword -e "CREATE DATABASE hive DEFAULT CHARACTER SET latin1;"

tar xvfz /vagrant/examples/foodmart_mysql.sql.tar.gz -C /tmp/
mysql -uroot -pmypassword test < /tmp/foodmart_mysql.sql

```

Hadoop:
```
# Confs
cp /vagrant/confs/hadoop/* /etc/hadoop/conf/

cp /vagrant/confs/hive/hive-site.xml /etc/hive/conf/
cp /vagrant/confs/hive/hive-env.sh /etc/hive/conf/
cp /vagrant/confs/tez/tez-site.xml /etc/tez/conf/

cp /vagrant/confs/hue/hue.ini /etc/hue/conf/

mkdir -p /hadoop/hdfs/namesecondary
mkdir -p /hadoop/hdfs/namenode
mkdir -p /hadoop/hdfs/data
chown -R hdfs:hadoop /hadoop/hdfs

mkdir -p /hadoop/yarn/local
chown -R yarn:hadoop /hadoop/yarn

# Ganglia
cp /vagrant/confs/ganglia/*.conf /etc/ganglia/
service gmond restart
service gmetad restart
service httpd restart

# Format HDFS Namenode
sudo /etc/init.d/hadoop-hdfs-namenode init

# Start HDFS services
for i in hadoop-hdfs-namenode hadoop-hdfs-datanode ; do sudo service $i start ; done

# Init HDFS
sudo /usr/lib/hadoop/libexec/init-hdfs.sh

# Start YARN and Job HistoryServer
sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-yarn-nodemanager start
sudo service hadoop-mapreduce-historyserver start

```

Hive and Tez:
```
# Tez
sudo -u hdfs hadoop fs -mkdir -p /apps/tez/
sudo -u hdfs hdfs dfs -copyFromLocal /usr/lib/tez/* /apps/tez
sudo -u hdfs hdfs dfs -chown -R  hdfs:users /apps/tez

sudo -u hdfs hadoop fs -mkdir -p /apps/hive/install
sudo -u hdfs hadoop fs -chown -R hive:hadoop /apps/hive
sudo -u hive hadoop fs -copyFromLocal /usr/lib/hive/lib/hive-exec-0.14.0.jar /apps/hive/install/hive-exec-0.14.0.jar

# Add symlinks for JDBC drivers
ln -sf /usr/share/java/mysql-connector-java.jar /usr/lib/hive/lib/

for i in hive-metastore hive-hcatalog-server hive-server2 ; do sudo service $i start ; done
```


Smoke tests:
```
# YARN
sudo -u hdfs hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 2 2
# Tez
sudo -u hdfs hadoop fs -mkdir /tmp/data
sudo -u hdfs hadoop fs -put /etc/passwd /tmp/data/
sudo -u hdfs hadoop jar /usr/lib/tez/tez-mapreduce-examples-0.4.0.2.1.2.0-402.jar orderedwordcount -DUSE_TEZ_SESSION=true /tmp/data/ /tmp/tez-out

```


Service Management:
```
chkconfig hadoop-hdfs-namenode on
chkconfig hadoop-hdfs-datanode on 
chkconfig hadoop-yarn-nodemanager on
chkconfig hadoop-mapreduce-historyserver on
chkconfig hadoop-yarn-resourcemanager on
chkconfig hadoop-hdfs-secondarynamenode off
chkconfig hadoop-hdfs-zkfc off
chkconfig hadoop-httpfs off
chkconfig mysqld on
chkconfig ntpd on
chkconfig zookeeper-server on
chkconfig hive-metastore on
chkconfig hive-hcatalog-server off
chkconfig hive-server off
chkconfig hive-server2 on
chkconfig httpd off
chkconfig gmond off
chkconfig gmetad off
chkconfig hbase-master off
chkconfig hbase-regionserver off
chkconfig hbase-thrift off
chkconfig hbase-thrift2 off
chkconfig hbase-rest off

# Disable iptables
/sbin/chkconfig --level 2345 iptables off
/sbin/chkconfig --level 2345 ip6tables off
```
