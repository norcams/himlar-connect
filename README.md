# himlar-connect

Himlar+Connect integration development env

## Goals

### Openstack definitions

<dl>
<dt>User</dt>
  <dd>An identity able to authenticate with the Keystone service.</dd>

<dt>Project</dt>
  <dd>A project is a collection of instances and services related to a set of
  users.</dd>

<dt>Group</dt>
  <dd>A user can be member of one or several groups.</dd>

</dl>

UH IaaS definitions
-------------------

<dl>
<dt>User</dt>
  <dd>A person within the higher academic sector with an identity record in
  FEIDE.</dd>

<dt>Personal project</dt>
  <dd>Each user in UH IaaS is given access to a personal project by default.
  This project has a limited resource quota but exposes all available
  services</dd>

</dl>

## Integration phase 1 (MVP)

### Use case summary

- A user want to access the IaaS service and logs in
- As part of the first logon process(?) a personal project is created and
  access granted to it for the user
- An administrator is able to identify the user as belonging to an organization

### Design outline

A separate registration service configured as being the same application as
IaaS through Connect. The registration service is split into a frontend, queue
and backend. API calls against Openstack is only run by the backend service.

When registering, the backend service creates Openstack objects as needed for
the user to be able to log in and access their personal project.

## Integration phase 2

### Use case summary

- A user wants to collaborate with other users using the IaaS service
- The user creates an adhoc-group in FEIDE Connect, adding the required users
  to it
- The adhoc group is (auto)provisioned as a project in the IaaS service
- Members of the adhoc group are mapped as being members of the project in the
  IaaS service
- An administrator is able to identify each user belonging to the
  adhoc-group-provisioned project as belonging to an organization

## Using the vagrant based dev env

```bash
git clone git@github.com:norcams/himlar-connect.git
vagrant up
```

Access http://10.0.3.11 in your local browser. Domain is 'Default', password
admin/himlardev

```bash
vagrant ssh
sudo -i
```

Credentials for using the openstack cli are found in /root

```bash
source keystonerc_admin
set | grep OS_

openstack service list
openstack endpoint list
openstack endpoint show keystone

openstack token issue
openstack role list
openstack user list

openstack domain list
openstack domain show Connect
```

* Keystone runs as a WSGI-process through Apache
* Its configuration is found in /etc/keystone/
* Apache-config in /etc/httpd/conf.d/10-keystone_wsgi_main.conf

Packages and paths

```bash
rpm -qa | grep keystone
rpm -ql python-keystone
```

Keystone is at /usr/lib/python2.7/site-packages/keystone



