#!/bin/bash -eux
source /root/keystonerc_admin_v3
openstack role add --project-domain connect --project connect_project --group dataporten_group --group-domain connect _member_
