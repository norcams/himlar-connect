#!/bin/bash -eux

vhostconf="/etc/httpd/conf.d/10-keystone_wsgi_main.conf"
scopes="openid email profile userid-feide"
redirurl1="http://10.0.3.11:5000/v3/OS-FEDERATION/identity_providers/dataporten/protocols/oidc/auth/redirect"
redirurl2="http://10.0.3.11:5000/v3/auth/OS-FEDERATION/websso/oidc/redirect"

if !grep -q OIDC "${vhostconf}"
then
    tmpfile=$(mktemp)
    head -n-1 "${vhostfile}" > "${tmpfile}"
    cat >>"${tmpfile}" <<EOF
    OIDCClaimPrefix "OIDC-"
    OIDCResponseType "code"
    OIDCScope "$scopes"
    OIDCProviderMetadataURL https://auth.feideconnect.no/.well-known/openid-configuration
    OIDCClientID OAUTH_CLIENT_ID_FROM_DASHBOARD
    OIDCClientSecret OAUTH_CLIENT_SECRET_DASHBOARD
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

    echo "Replace OAUTH_CLIENT_ID_FROM_DASHBOARD and OAUTH_CLIENT_SECRET_DASHBOARD in ${vhostfile} with relevant values from dashboard.feideconnect.no. Register the application with these scopes: $scopes and these redirect urls: $redirurl1 $redirurl2"
fi
