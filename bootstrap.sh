#!/bin/bash
# Set hostname
hostname salt

# Salt repo
rpm --import https://repo.saltstack.com/yum/redhat/6/x86_64/latest/SALTSTACK-GPG-KEY.pub
cat >/etc/yum.repos.d/saltstack.repo <<EOS
[saltstack-repo]
name=SaltStack repo for RHEL/CentOS 6
baseurl=https://repo.saltstack.com/yum/redhat/6/\$basearch/latest
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/redhat/6/\$basearch/latest/SALTSTACK-GPG-KEY.pub
EOS

# Full update
yum clean expire-cache
yum -y update

# Gitfs dependencies
yum -y install git
yum -y install python26-pip
pip-2.6 install gitpython

# Salt master
yum -y install salt-master
chkconfig salt-master on
service salt-master start

# Salt minion
echo "127.0.0.1 salt" >> /etc/hosts
yum -y install salt-minion
chkconfig salt-minion on
service salt-minion start
