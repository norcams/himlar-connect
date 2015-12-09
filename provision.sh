#!/bin/bash -eux

for s in /opt/himlar/provision/*.sh; do
  if [ -f $s -a -x $s ]; then
    $s
  fi
done

