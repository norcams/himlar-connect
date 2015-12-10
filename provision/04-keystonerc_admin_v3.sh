#!/bin/bash -eux

# Create a keystone v3 admin rc file
echo "
unset OS_SERVICE_TOKEN
export OS_USERNAME=admin
export OS_PASSWORD=himlardev
export OS_AUTH_URL=http://10.0.3.11:5000/v3
export PS1='[\u@\h \W(keystone_admin)]\$ '

export OS_TENANT_NAME=admin
export OS_REGION_NAME=RegionOne
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3
" > /root/keystonerc_admin_v3

