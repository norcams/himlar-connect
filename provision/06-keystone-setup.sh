#!/bin/bash -eux

puppet apply --modulepath=/usr/share/openstack-puppet/modules puppet/keystone.pp
