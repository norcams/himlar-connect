# himlar-connect

Himlar+Connect integration development env

## Definitions

### Defined by OpenStack

<dl>
<dt>User</dt>
  <dd>An identity able to authenticate with the Keystone service.</dd>

<dt>Project</dt>
  <dd>A project is a collection of instances and services related to a set of
  users.</dd>

<dt>Group</dt>
  <dd>A user can be member of one or several groups.</dd>

</dl>

### Defined by UH IaaS

<dl>
<dt>User</dt>
  <dd>A person within the higher academic sector with an identity record in
  FEIDE.</dd>

<dt>Personal project</dt>
  <dd>Each user in UH IaaS is given access to a personal project by default.
  This project has a limited resource quota but exposes all available
  services</dd>

</dl>

## Milestones

## [Integration phase 1 (MVP)][ghms1]

- Assign tasks using the [github milestone][ghms1]

[ghms1]: https://github.com/norcams/himlar-connect/milestones/Integration%20phase%201

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

## [Integration phase 2][ghms2]

- Assign tasks using the [github milestone][ghms2]

[ghms2]: https://github.com/norcams/himlar-connect/milestones/Integration%20phase%202

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
cd himlar-connect
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

### To register the dev env Horizon/Keystone in Connect

1) Create two files in the project directory with the OAuth client id and
   secret from http://dashboard.feideconnect.no

```bash
echo <my_oauth_client_id> > oauth_client_id
echo <my_oauth_client_secret> > oauth_client_secret
```

2) Run vagrant rsync and provision

```bash
vagrant rsync && vagrant provision
```

3) Register the application in FEIDE Connect using the values in the output


