#!/bin/bash -eux

# Per http://adam.younglogic.com/2015/05/rdo-v3-only/
# Add identity API v3 settings to Horizon config
grep -q ^OPENSTACK_API_VERSIONS /etc/openstack-dashboard/local_settings || echo "
OPENSTACK_API_VERSIONS = {
     'identity': 3
}
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'
" >> /etc/openstack-dashboard/local_settings

grep -q oidc /etc/openstack-dashboard/local_settings || echo "
WEBSSO_ENABLED = True

WEBSSO_CHOICES = (
      ("credentials", _("Keystone Credentials")),
      ("oidc", _("Dataporten")),
    )
" >> /etc/openstack-dashboard/local_settings

systemctl restart httpd

