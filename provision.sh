#!/bin/bash -eux

if [[ ! -f /var/tmp/provision_done ]]; then
  yum update -y
  rpm -q rdo-release || yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
  rpm -q openstack-packstack || yum install -y openstack-packstack
  packstack --answer-file=/opt/himlar/himlarconnect.txt \
   && touch /var/tmp/provision_done \
  rpm -q mod_auth_openidc || yum install -y https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.6/mod_auth_openidc-1.8.6-1.el7.centos.x86_64.rpm
  mv /etc/httpd/conf.modules.d/10-auth_openidc.conf /etc/httpd/conf.d/auth_openidc.load
  reboot
fi

