$keystone_conf = '/etc/keystone/keystone.conf'

ini_setting { 'authmethods':
  ensure  => present,
  path    => $keystone_conf,
  section => 'auth',
  setting => 'methods',
  value   => 'external,password,token,oauth1,oidc'
}

ini_setting { 'authoidcclass':
  ensure  => present,
  path    => $keystone_conf,
  section => 'auth',
  setting => 'oidc',
  value   => 'keystone.auth.plugins.mapped.Mapped'
}

ini_setting { 'remoteidattibute':
  ensure  => present,
  path    => $keystone_conf,
  section => 'oidc',
  setting => 'remote_id_attribute',
  value   => 'OIDC-iss'
}

ini_setting { 'trusted dashboard':
  ensure  => present,
  path    => $keystone_conf,
  section => 'federation',
  setting => 'trusted_dashboard',
  value   => 'http://10.0.2.15/dashboard/auth/websso/'
}
