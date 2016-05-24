#!/bin/bash -eux

rpm -q rdo-release || yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-liberty/rdo-release-liberty-2.noarch.rpm
rpm -q openstack-packstack || yum install -y openstack-packstack

if [[ ! -f /var/tmp/packstack_done ]]; then
  packstack --install-hosts=10.0.3.11 \
    --default-password=himlardev \
    --mariadb-install=y \
    --os-glance-install=y \
    --os-cinder-install=n \
    --os-manila-install=n \
    --os-nova-install=y \
    --os-neutron-install=y \
    --os-horizon-install=y \
    --os-swift-install=n \
    --os-ceilometer-install=n \
    --os-sahara-install=n \
    --os-heat-install=n \
    --os-trove-install=n \
    --os-ironic-install=n \
    --os-client-install=y \
    --os-debug-mode=y \
    --nagios-install=n \
    --use-epel=y \
  && touch /var/tmp/packstack_done
fi
