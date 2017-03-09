#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="${SCRIPT_DIR}/../.."

source "${PROJECT_DIR}/scripts/buildconfig.sh"

organization="$(getBuildConfig .image.organization)"
name="$(getBuildConfig .image.name)"
root_folder="$(getBuildConfig .image.root_folder)"
shell_user="$(getBuildConfig .image.shell_user)"
configuration_folder="$(getBuildConfig .configuration.folder)"
configuration_filename="$(getBuildConfig .configuration.filename)"
ansible_version="$(getBuildConfig .image.software_versions.ansible)"
terraform_version="$(getBuildConfig .image.software_versions.terraform)"
docker_version="$(getBuildConfig .image.software_versions.docker)"

image_name="${organization}/${name}"

docker build \
    "${PROJECT_DIR}/docker-image" \
    --tag "${image_name}" \
    --build-arg name="${name}" \
    --build-arg root_folder="${root_folder}" \
    --build-arg shell_user="${shell_user}" \
    --build-arg configuration_folder="${configuration_folder}" \
    --build-arg configuration_filename="${configuration_filename}" \
    --build-arg ansible_version="${ansible_version}" \
    --build-arg terraform_version="${terraform_version}" \
    --build-arg docker_version="${docker_version}"


docker tag "${image_name}" "${image_name}:development"
