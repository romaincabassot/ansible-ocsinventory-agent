#!/bin/bash

set -e

distro=$1
distro_version=$2
init=$3
run_opts=$4
ansible_version=$5

container_id="$(mktemp)"
echo "Distro=${distro} DistroVersion=${distro_version} Init=${init} run_opts=${run_opts} AnsibleVersion=${ansible_version} container_id=${container_id}"
docker run --detach --volume="${CI_PROJECT_DIR}":/etc/ansible/roles/romaincabassot.ansible-ocsinventory-agent:ro ${run_opts} ${distro}:${distro_version} "${init}" > "${container_id}"
docker top "${container_id}"