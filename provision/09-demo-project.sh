#!/bin/sh

# Enroll dataporten users in the demo project for now
/usr/bin/openstack role add --project demo --group  dataporten_group _member_
