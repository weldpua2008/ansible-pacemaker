# Moran Frimer - Exam Notes

## support of Ubuntu/Debian or Suse distributions

I've added support for Ubuntu distribution
* I used the package module to support package installation on different OSes - [Ansible Package Docs](https://docs.ansible.com/ansible/2.5/modules/package_module.html)
* HAproxy and IFmon OCF resource agents are compatible for Ubuntu
* In the case of cm.agent OCF resource agent, there is specific hard stop command for RHEL-compatible 7 and another for all other linux distributions. In that case I've used the el6 template for all other distributions. [Starting, Stopping, and Restarting Cloudera Manager Agents](https://www.cloudera.com/documentation/enterprise/5-7-x/topics/cm_ag_agents.html)


## Idempotency & Playbook test via Travis / Circle-CI/ Gitlab or any other

### Notes:
I've decide to write a `Jenkinsfile` due to time limitations as I have little or no experience with other CI tools.

I've used Molecule python package - first I though I will be able to use it's docker driver to run full test cycle including idempotency, but unfortunately the pacemaker playbook doesn't support docker of any linux distribution.
Eventually, I used it only for linting as I already was invested in it.

For the idempotency test as for what I read to verify idempotency you need to run the playbook twice and see that in the second time no actions was performed by the playbook (changed=0).
In order to do that you need to have ssh to at least one host to run the playbook on it.
I've tried to use docker but the playbook has task that fails on docker (like checking services for example).
I'm afraid I ran out of time to setup vagrant host and check the playbook on it.

**To conclude**, in order to run the idempotency test, `Jenkinsfile` assumes the in the `tests/inventory` file are available hosts to run the playbook on them.

### So what I decided to do:
I've added `Jenkinsfile` with groovy script to test the playbook
It runs the following steps:
* Lint test - checking for syntax errors in the playbook (using Molecule python package)
* Idempotence test - Runs the playbook twice. If no tasks will be marked as changed the playbook will be considered idempotent.


## Please split it by tags to simplify maintenance (e.g. configure, update)

I've splitted the Role Task into 4 tags:
* verify - Tasks that checks that required vars are set up.
* setup - Tasks that checks that pacemaker is up and running with proper config and auth files
* deploy - Tasks that put all the template files in place (ocf resource agents) and waits for cluster to properly start
* configure - Tasks that uses the `pcs` command to configure the cluster

## VagrantFile or Dockerfile for this playbook to give a QA test it

I've added Dockerfile that install Ansible and Molecule.
Example of how to use it when you `cd` in the ansible-pacemaker role:
* Build the docker image
`docker build . -t ansible-master:jessie`
* Run the docker with the following arguments and a CMD for your choice
`docker run --rm -it -v ~/.ssh/id_rsa:/root/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub -v $(pwd):/playbook/roles/ansible-pacemaker ansible-master:jessie CMD`

* You can run the playbook with the following command:
`docker run --rm -it -v ~/.ssh/id_rsa:/root/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub -v $(pwd):/playbook/roles/ansible-pacemaker ansible-master:jessie ansible-playbook -i tests/inventory tests/example-playbook.yml`

## In Conclusion
To be honest, I not very happy with the result as I failed to setup a docker environment (ansible server and hosts) for this pacemaker role (In the time I assign to this exam).
Maybe if I'd focused on Vagrant to begin with, I would be able to get to a more satisfying result for me.
