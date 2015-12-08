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



# Create a keystone v3 api rc file
echo "
unset OS_SERVICE_TOKEN
export OS_USERNAME=admin
export OS_PASSWORD=himlardev
export OS_AUTH_URL=http://10.0.2.15:5000/v3
export PS1='[\u@\h \W(keystone_admin)]\$ '

export OS_TENANT_NAME=admin
export OS_REGION_NAME=RegionOne
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3
" > /root/keystonerc_v3_admin

# Add settings to Horizon config
grep -q OPENSTACK_API_VERSIONS || echo "
OPENSTACK_API_VERSIONS = {
     "identity": 3
}
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'
" >> /etc/openstack/dashboard/local_settings

mysql  --user keystone_admin --password=himlardev   keystone -e "update endpoint set url = 'http://10.0.2.15:5000/v3' where  interface ='public' and  service_id =  (select id from service where service.type = 'identity');"
mysql  --user keystone_admin --password=himlardev   keystone -e "update endpoint set url = 'http://10.0.2.15:5000/v3' where  interface ='internal' and  service_id =  (select id from service where service.type = 'identity');"
mysql  --user keystone_admin --password=himlardev   keystone -e "update endpoint set url = 'http://10.0.2.15:35357/v3' where  interface ='admin' and  service_id =  (select id from service where service.type = 'identity');"

# TODO: Fix nova and glance per https://gist.github.com/jhellan

