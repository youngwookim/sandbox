echo "10.10.10.10 sandbox.example.com sandbox" >> /etc/hosts

cat > /etc/sysconfig/network <<EOF1
NETWORKING=yes
HOSTNAME=sandbox.example.com
EOF1

hostname sandbox.example.com

echo "vm.swappiness = 0" >> /etc/sysctl.conf

# Disable SELINUX
sed -i -e 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config

# Disable iptables
/sbin/chkconfig --level 2345 iptables off
/sbin/chkconfig --level 2345 ip6tables off

# EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# RepoForge(rpmforge)
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Git
yum install -y --enablerepo=rpmforge-extras git

yum install -y java-1.7.0-openjdk-devel snappy snappy-devel wget make rpm-build fuse-devel cmake fuse-libs redhat-rpm-config lzo-devel autoconf automake redhat-lsb nc createrepo asciidoc python-devel libxml2-devel libxslt-devel cyrus-sasl-devel openldap-devel mysql-devel xmlto nodejs npm

npm install -g brunch@1.7.17

wget http://apache.mirror.cdnetworks.com//ant/binaries/apache-ant-1.9.4-bin.tar.gz
wget http://mirror.apache-kr.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz 
wget http://archive.apache.org/dist/forrest/0.9/apache-forrest-0.9.tar.gz

# Ant & Maven
tar xvfz apache-ant-1.9.4-bin.tar.gz --directory=/opt/
tar xvfz apache-maven-3.2.5-bin.tar.gz --directory=/opt/
tar xvfz apache-forrest-0.9.tar.gz --directory=/opt/
echo "export JAVA_HOME=/usr/lib/jvm/java-openjdk" >> /etc/profile.d/java.sh
echo "export ANT_HOME=/opt/apache-ant-1.9.4" >> /etc/profile.d/ant.sh
echo "export MAVEN_HOME=/opt/apache-maven-3.2.5" >> /etc/profile.d/maven.sh
echo "export FORREST_HOME=/opt/apache-forrest-0.9" >> /etc/profile.d/forrest.sh

# ProtocolBuffers 2.5
wget http://download.opensuse.org/repositories/home:/mrdocs:/protobuf-rpm/CentOS_CentOS-6/home:mrdocs:protobuf-rpm.repo -O /etc/yum.repos.d/protobuf.repo
yum install -y protobuf-devel

# Gradle
wget https://services.gradle.org/distributions/gradle-2.0-bin.zip
unzip gradle-2.0-bin.zip -d /opt/
echo "export GRADLE_HOME=/opt/gradle-2.0" >> /etc/profile.d/gradle.sh

# Scala
wget http://downloads.typesafe.com/scala/2.11.4/scala-2.11.4.tgz
tar xvfz scala-2.11.4.tgz --directory=/opt/
echo "export SCALA_HOME=/opt/scala-2.11.4" >> /etc/profile.d/scala.sh

# PATH
echo "export PATH=\$JAVA_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$GRADLE_HOME/bin:\$SCALA_HOME/bin:\$PATH" >> /etc/profile

# Cleanup
yum -y update
yum -y clean all

