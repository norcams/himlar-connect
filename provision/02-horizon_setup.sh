#!/bin/bash -eux

# Per http://adam.younglogic.com/2015/05/rdo-v3-only/
# Add identity API v3 settings to Horizon config
if ! grep -q ^OPENSTACK_API_VERSIONS /etc/openstack-dashboard/local_settings; then
  echo "
OPENSTACK_API_VERSIONS = {
     'identity': 3
}
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'Default'

WEBSSO_ENABLED = True

WEBSSO_CHOICES = (
      ('credentials', _('Keystone Credentials')),
      ('oidc', _('Dataporten')),
    )
" >> /etc/openstack-dashboard/local_settings
  systemctl restart httpd
fi
