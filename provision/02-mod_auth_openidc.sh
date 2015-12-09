#!/bin/bash -eux
rpm -q epel-release || yum -y install epel-release
rpm -q mod_auth_openidc || yum install -y https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.6/mod_auth_openidc-1.8.6-1.el7.centos.x86_64.rpm

if [[ ! -f /etc/httpd/conf.d/auth_openidc.load ]]; then
  mv /etc/httpd/conf.modules.d/10-auth_openidc.conf /etc/httpd/conf.d/auth_openidc.load
fi

systemctl restart httpd

