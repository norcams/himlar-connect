#!/usr/bin/env python
import ConfigParser
import requests
import json

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

resp = requests.get('http://localhost:35357/v3/domains', headers=headers)
domains = resp.json()['domains']
domain_id = None
for domain in domains:
    if domain['name'] == u'Connect':
        domain_id = domain['id']

if not domain_id:
    raise Exception('Did not find domain "Connect"')

with open('/opt/himlar/json/create-mapping.json') as fh:
    data = fh.read()
    data = data.replace('CONNECT_DOMAIN_ID', domain_id)
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

data = {
    'group': {
        'description': 'Gruppe for test med dataporten',
        'domain_id': domain_id,
        'name': 'dataporten_group',
    }
}
response = requests.post('http://localhost:35357/v3/groups',
                         headers=headers, data=json.dumps(data))
if response.status_code not in (201, 409):
    raise Exception('Could not create group')
