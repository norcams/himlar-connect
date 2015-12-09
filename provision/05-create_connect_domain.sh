#!/bin/bash -eux

puppet apply --modulepath=/usr/share/openstack-puppet/modules -e '

keystone_domain { "Connect":
  ensure       => present,
  description => "Federated users from FEIDE Connect",
  is_default  => false,
}

'
