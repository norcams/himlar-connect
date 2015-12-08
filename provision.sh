#!/bin/bash -eux

if [[ ! -f /var/tmp/openstack_done ]]; then
  yum update -y
  rpm -q rdo-release || yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
  rpm -q openstack-packstack || yum install -y openstack-packstack
  packstack --answer-file=/opt/himlar/himlarconnect.txt \
   && touch /var/tmp/openstack_done
fi

sed -i 's/ServerAlias\ 10.0.2.15/ServerAlias\ 10.0.3.11/' /etc/httpd/conf.d/15-horizon_vhost.conf
rpm -q mod_auth_openidc || yum install -y https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.6/mod_auth_openidc-1.8.6-1.el7.centos.x86_64.rpm
if [ ! -f /etc/httpd/conf.d/auth_openidc.load ]; then
  mv /etc/httpd/conf.modules.d/10-auth_openidc.conf /etc/httpd/conf.d/auth_openidc.load
fi

