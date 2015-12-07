#!/bin/bash -eux

if [[ ! -f /opt/provision_done ]]; then
  yum update -y
  rpm -q rdo-release || yum install -y https://www.rdoproject.org/repos/rdo-release.rpm
  rpm -q openstack-packstack || yum install -y openstack-packstack
  packstack --answer-file=/opt/himlar/himlarconnect.txt \
   && touch /tmp/provision_done \
   && reboot
fi

