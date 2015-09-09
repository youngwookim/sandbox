# Disable ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

# Disable iptables
service iptables stop
service ip6tables stop
chkconfig iptables off
chkconfig ip6tables

# EPEL
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Bootstrap
yum install -y ntpd postgresql-jdbc

# Ambari
cd /etc/yum.repos.d/ && wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.0/ambari.repo && cd -

yum install -y ambari-server ambari-agent

ambari-server setup -s

service ambari-server start
service ambari-agent start
