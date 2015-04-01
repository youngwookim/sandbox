# Disable SELINUX
sed -i -e 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-fedora-20.noarch.rpm

yum -y install git puppet
yum -y update vim-minimal

git clone https://github.com/apache/bigtop.git
cd bigtop/bigtop_toolchain
puppet apply --debug --modulepath=/home/vagrant/bigtop -e "include bigtop_toolchain::installer"
