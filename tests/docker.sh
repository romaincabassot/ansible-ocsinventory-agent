#!/bin/bash

set -e

distro=$1
distro_version=$2
init=$3
run_opts=$4
ansible_version=$5

echo "Distro=${distro} DistroVersion=${distro_version} Init=${init} run_opts=${run_opts} AnsibleVersion=${ansible_version} container_id=${container_id}"

container_id="$(mktemp)"
docker run --detach --volume="${CI_PROJECT_DIR}":/etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent:ro ${run_opts} ${distro}:${distro_version} "${init}" > "${container_id}"

# Install EPEL repository for pip package installation
if [ "${distro}" == "centos" ] && [ "${distro_version}" == "6" ]; then docker exec --tty "$(cat ${container_id})" env TERM=xterm rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm; fi
if [ "${distro}" == "centos" ] && [ "${distro_version}" == "7" ]; then docker exec --tty "$(cat ${container_id})" env TERM=xterm rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; fi

# Ansible installation via pip
docker exec --tty "$(cat ${container_id})" env TERM=xterm yum -y install gcc gmp-devel python-devel openssl-devel findutils
docker exec --tty "$(cat ${container_id})" env TERM=xterm yum -y install python-pip
docker exec --tty "$(cat ${container_id})" env TERM=xterm pip install --upgrade pip
if [ "${distro}" == "centos" ] && [ "${distro_version}" == "6" ]; then docker exec --tty "$(cat ${container_id})" env TERM=xterm pip install pyopenssl; fi
docker exec --tty "$(cat ${container_id})" env TERM=xterm pip install setuptools --upgrade
docker exec --tty "$(cat ${container_id})" env TERM=xterm pip install ansible==${ansible_version}

# Install the ansible galaxy roles included in the test playbook
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-galaxy install geerlingguy.repo-epel
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-galaxy install geerlingguy.repo-remi

# Ansible role syntax check.
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/test.yml -i /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/inventory --syntax-check

# Ansible role execution.
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook -vvv /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/test.yml -i /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/inventory

# Test Ansible role idempotence.
idempotence=$(mktemp)
docker exec "$(cat ${container_id})" ansible-playbook /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/test.yml -i /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/inventory | tee -a ${idempotence}
tail ${idempotence} \
| grep -q 'changed=0.*failed=0' \
&& (echo 'Idempotence test: pass' && exit 0) \
|| (echo 'Idempotence test: fail' && exit 1)


docker exec --tty "$(cat ${container_id})" env TERM=xterm /usr/sbin/ocsinventory-agent --stdout
docker exec --tty "$(cat ${container_id})" env TERM=xterm /usr/sbin/ocsinventory-agent --local=/var/lib/ocsinventory-agent

# Debug OCS inventory log if file exist
echo "ocsinventory-agent.log:"; if [ -f /var/log/ocsinventory-agent/ocsinventory-agent.log ]; then cat /var/log/ocsinventory-agent/ocsinventory-agent.log; fi

# Run tests in Container
docker exec --tty "$(cat ${container_id})" env TERM=xterm /bin/bash /etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent/tests/test_inside_docker.sh