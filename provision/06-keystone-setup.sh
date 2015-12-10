#!/bin/bash -eux

puppet apply --modulepath=/usr/share/openstack-puppet/modules /opt/himlar/puppet/keystone.pp
