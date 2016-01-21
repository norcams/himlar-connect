#!/bin/bash -eux

if [[ ! -f /var/tmp/base_done ]]; then
  yum clean all
  yum update -y
  yum -y install chrony
  systemctl enable chronyd
  systemctl start chronyd
  touch /var/tmp/base_done
fi
