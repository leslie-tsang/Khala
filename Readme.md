Name
=================

Ansible Khala Oracle (AKO) - A shim container for ansible to run everywhere

Table of Contents
=================

* [Name](#name)
* [Description](#description)
    * [For Users](#for-users)
    * [For Bundle Maintainers](#for-bundle-maintainers)
* [Dependence](#dependence)

Description
======

AKO is a full-fledged ansible docker container by bundling the standard ansible core,
lots of playbook, as well as most of their external dependencies.

This bundle is maintained by Leslie Tsang (leslie.tsang).

Because most of the ansible playbooks are developed by the bundle maintainers, it can ensure
that all these modules are played well together.

For Users
---------
To reproduce the ansible container, just do

```bash
make
```

at the top of the bundle source tree.

Dependence
======
Please note that you may need to install some extra dependencies, like `make`, `docker`, and `docker-compose`.
On Centos 7, for example, installing the dependencies
is as simple as running the following commands:

```bash
sudo yum install -y make docker-ce docker-ce-cli containerd.io \
  && sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

[Back to TOC](#table-of-contents)
