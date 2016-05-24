#!/bin/bash -eux

rpm -q epel-release || yum -y install epel-release
rpm -q mod_auth_openidc || yum install -y https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.6/mod_auth_openidc-1.8.6-1.el7.centos.x86_64.rpm

if [[ ! -f /etc/httpd/conf.d/auth_openidc.load ]]; then
  mv /etc/httpd/conf.modules.d/10-auth_openidc.conf /etc/httpd/conf.d/auth_openidc.load
fi

vhostfile="/etc/httpd/conf.d/10-keystone_wsgi_main.conf"
scopes="openid email profile userid-feide"
redirurl1="http://10.0.3.11:5000/v3/OS-FEDERATION/identity_providers/dataporten/protocols/oidc/auth/redirect"
redirurl2="http://10.0.3.11:5000/v3/auth/OS-FEDERATION/websso/oidc/redirect"
oauth_client_id="$(cat /opt/himlar/oauth_client_id)"
oauth_client_secret="$(cat /opt/himlar/oauth_client_secret)"

if ! grep -q OIDC "${vhostfile}"
then
    tmpfile=$(mktemp)
    head -n-1 "${vhostfile}" > "${tmpfile}"
    cat >>"${tmpfile}" <<EOF
    OIDCClaimPrefix "OIDC-"
    OIDCResponseType "code"
    OIDCScope "$scopes"
    OIDCProviderMetadataURL https://auth.dataporten.no/.well-known/openid-configuration
    OIDCClientID "$oauth_client_id"
    OIDCClientSecret "$oauth_client_secret"
    OIDCCryptoPassphrase openstack
    OIDCRedirectURI $redirurl1
    OIDCRedirectURI $redirurl2

    <Location ~ "/v3/auth/OS-FEDERATION/websso/oidc">
      AuthType openid-connect
      Require valid-user
    </Location>
    <LocationMatch /v3/OS-FEDERATION/identity_providers/.*?/protocols/oidc/auth>
      AuthType openid-connect
      Require valid-user
      LogLevel debug
    </LocationMatch>
EOF
    tail -n-1 "${vhostfile}" >> "${tmpfile}"
    mv "${tmpfile}" "${vhostfile}"

    echo "------------------------------------------"
    echo "Register the application in FEIDE Connect:
    echo
    echo "scopes:        $scopes"
    echo "redirect urls: $redirurl1"
    echo                 $redirurl2"
    echo
    echo "------------------------------------------"
fi

systemctl restart httpd

