#!/bin/bash -eux

yum history | grep "Update" || (yum clean all; yum update -y)

