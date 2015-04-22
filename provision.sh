wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update

apt-get -y install git 
apt-get -y install puppet

git clone https://github.com/apache/bigtop.git
cd bigtop/bigtop_toolchain
puppet apply --debug --modulepath=/home/vagrant/bigtop -e "include bigtop_toolchain::installer"
chown vagrant:vagrant -R /home/vagrant/bigtop                                                                                                          
