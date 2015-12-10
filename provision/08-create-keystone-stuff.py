#!/usr/bin/env python
import ConfigParser
import requests

cp = ConfigParser.SafeConfigParser()
cp.read('/etc/keystone/keystone.conf')
token = cp.get('DEFAULT', 'admin_token')

baseurl = 'http://localhost:35357/v3/OS-FEDERATION'

headers = {
    'X-Auth-Token': token,
    'Content-Type': 'application/json',
}
with open('/opt/himlar/json/create-idp.json') as fh:
    data = fh.read()
    response = requests.put(baseurl + '/identity_providers/dataporten',
                            headers=headers, data=data)
    if response.status_code == 409:
        response = requests.patch(baseurl + '/identity_providers/dataporten',
                                  headers=headers, data=data)
    response.raise_for_status()

with open('/opt/himlar/json/create-mapping.json') as fh:
    data = fh.read()
    response = requests.put(baseurl + '/mappings/dataporten',
                            headers=headers, data=data)
    if response.status_code == 409:
        response = requests.patch(baseurl + '/mappings/dataporten',
                                  headers=headers, data=data)
    response.raise_for_status()

with open('/opt/himlar/json/create-protocol.json') as fh:
    data = fh.read()
    response = requests.put(baseurl + '/identity_providers/dataporten/protocols/oidc',
                            headers=headers, data=data)
    if response.status_code == 409:
        response = requests.patch(baseurl + '/identity_providers/dataporten/protocols/oidc',
                                  headers=headers, data=data)
    response.raise_for_status()
