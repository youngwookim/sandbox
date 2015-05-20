# Disable SELINUX
sed -i -e 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config

# EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Puppetlabs
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# RepoForge(rpmforge)
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Git
yum install -y --enablerepo=rpmforge-extras git

yum -y install puppet unzip java-1.7.0-openjdk-devel

#git clone https://github.com/apache/bigtop.git
#cd bigtop
#./gradlew toolchain

#chown vagrant:vagrant -R /home/vagrant/bigtop                                                                                                          
