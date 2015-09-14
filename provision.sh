# YUM
# EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Puppetlabs
sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# RepoForge(rpmforge)
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Git
yum install -y --enablerepo=rpmforge-extras git

# Bootstrap
yum -y install puppet java-1.7.0-openjdk-devel sudo

git clone https://github.com/apache/bigtop.git
cd bigtop
./gradlew toolchain

chown vagrant:vagrant -R /home/vagrant/bigtop                                                                                                          
