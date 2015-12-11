#!/bin/sh

# Enroll dataporten users in the demo project for now
source /root/keystonerc_admin_v3
/usr/bin/openstack role add --project demo --group  dataporten_group _member_
