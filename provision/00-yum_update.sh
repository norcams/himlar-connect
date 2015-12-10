#!/bin/bash -eux

if [[ ! -f /var/tmp/yum_done ]]; then
  yum clean all
  yum update -y
  touch /var/tmp/yum_done
fi

