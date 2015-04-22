# Disable SELINUX
sed -i -e 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config

yum -y install git puppet unzip
yum -y update vim-minimal

git clone https://github.com/apache/bigtop.git

cd bigtop/
./gradlew toolchain

chown vagrant:vagrant -R /home/vagrant/bigtop

