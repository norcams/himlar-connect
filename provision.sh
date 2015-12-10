#!/bin/bash -eux

for s in /opt/himlar/provision/*; do
  if [ -f $s -a -x $s ]; then
    $s
  fi
done

