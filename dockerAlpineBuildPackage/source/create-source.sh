#!/bin/bash
set -e
declare C_DIR=$(dirname "$0")
cd "${C_DIR}" || exit 1
version=1.0
read -r -p "Enter the new AKP package name (test): " package_name
read -r -p "Enter the AKP package name version (1.0): " version

if [[ -z ${package_name} ]]; then
  package_name=test
fi

if [[ -z ${version} ]]; then
  version=1.0
fi

tar_ball_folder="${C_DIR}"/"${package_name}"-"${version}"
mkdir -p "${tar_ball_folder}"
printf "Add files in folder %s \n" "${tar_ball_folder}"/
