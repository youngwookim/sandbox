echo "vm.swappiness = 0" >> /etc/sysctl.conf

# EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# RepoForge(rpmforge)
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

yum install -y --enablerepo=rpmforge-extras git
yum install -y snappy snappy-devel make 

wget http://apache.mirror.cdnetworks.com//ant/binaries/apache-ant-1.9.4-bin.tar.gz
wget http://mirror.apache-kr.org/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz

# JDK7
wget --no-cookies \
--no-check-certificate \
--header "Cookie: oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm" \
-O /tmp/jdk-7-linux-x64.rpm

rpm -Uvh /tmp/jdk-7-linux-x64.rpm

alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_51/jre/bin/java 20000
alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_51/bin/jar 20000
alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_51/bin/javac 20000
alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.7.0_51/jre/bin/javaws 20000
alternatives --set java /usr/java/jdk1.7.0_51/jre/bin/java
alternatives --set javaws /usr/java/jdk1.7.0_51/jre/bin/javaws
alternatives --set javac /usr/java/jdk1.7.0_51/bin/javac
alternatives --set jar /usr/java/jdk1.7.0_51/bin/jar

# Ant & Maven
tar xvfz apache-ant-1.9.4-bin.tar.gz
tar xvfz apache-maven-3.2.1-bin.tar.gz
echo "export JAVA_HOME=/usr/java/default" >> /etc/profile.d/java.sh
echo "export ANT_HOME=/home/vagrant/apache-ant-1.9.4" >> /home/vagrant/.bashrc
echo "export MAVEN_HOME=/home/vagrant/apache-maven-3.2.1" >> /home/vagrant/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$PATH" >> /home/vagrant/.bashrc

# MySQL
#service mysqld start

#mysqladmin -u root password 'mypassword'

# MySQL user and databases
#mysql -uroot -pmypassword -e "CREATE USER 'root'@'localhost' IDENTIFIED BY 'mypassword';"
#mysql -uroot -pmypassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
#mysql -uroot -pmypassword -e "CREATE USER 'root'@'%' IDENTIFIED BY 'mypassword';"
#mysql -uroot -pmypassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"

#mysql -uroot -pmypassword -e "CREATE DATABASE hive DEFAULT CHARACTER SET latin1;"

# Cleanup
yum -y clean all

