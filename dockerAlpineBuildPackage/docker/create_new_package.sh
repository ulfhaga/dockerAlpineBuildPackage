#!/bin/bash
#
# NAME
#      create_new_package.sh - Create a Alpine package
# SYNOPSIS
#     create_new_package.sh
#
set -e

# Declare globals variables
shopt -s -o nounset
declare C_DIR=$(dirname "$0")
cd "${C_DIR}" || exit 1
declare -r PARENT_FOLDER=$(dirname "$(pwd)")
declare -r A_PORTS="${PARENT_FOLDER}"/target/aports
declare -r PACKAGES="${PARENT_FOLDER}"/target/packages
declare -g package_name

source globals

main() {
  read_package_name
  ./stop_docker_container.sh
  ./run_docker_container.sh
  build_apk_file
  update_apk_build_file
  create_tarball
  build_apk_package
  printf "The package can be found in folder %s\n" "${PACKAGES}"
  ./stop_docker_container.sh
}

build_apk_file() {
  docker exec -t -w /home/dev/aports apk-build newapkbuild "${package_name}"
}

build_apk_package() {
  docker exec -t -w /home/dev/aports/"${package_name}" apk-build abuild checksum
  docker exec -t -w /home/dev/aports/"${package_name}" apk-build abuild -r
}

create_tarball() {
  # Create tarball
  local tar_ball_root_dir="${package_name}"-"${pkg_version}"
  local tarball_directory="${PARENT_FOLDER}"/source/"${tar_ball_root_dir}"
  local tarball="${tarball_directory}".tar.gz
  echo -----------------------------------------------
  if [[ -d "${tarball_directory}" ]]; then
    tar -cvzf "${tarball}" -C "${PARENT_FOLDER}"/source "${tar_ball_root_dir}"
    mv "${tarball}" "${A_PORTS}"/"${package_name}"

  else
    printf "ERROR: The files for creating a tarball %s is missing. \n " "${tarball}"
    printf "Use the script ../source/create-source.sh to create one.\n"
    exit 3
  fi
}
read_package_name() {
  read -r -p "Enter the new AKP package name : " package_name
  if [[ -z ${package_name} ]]; then
    printf " Exiting. No package name entered. \n"
    exit 2
  fi
  if [[ -d "${A_PORTS}"/"${package_name}" ]]; then
    rm -fr "${A_PORTS}"/"${package_name}"
  fi
}

function update_apk_build_file() {
  # Update file APKBUILD
  APKBUILD_FILE="${A_PORTS}"/"${package_name}"/APKBUILD


  sed -i -e "s/pkgver=\"\"/pkgver=\""${pkg_version}"\"/" "${APKBUILD_FILE}"
  sed -i -e 's/source=\"\"/source=\"$pkgname-$pkgver.tar.gz\"/' "${APKBUILD_FILE}"
  sed -i -e "s/pkgdesc=\".*\"/pkgdesc=\""${pkg_desc}"\"/" "${APKBUILD_FILE}"
  sed -i -e "s/url=\".*\"/url=\""${url}"\"/" "${APKBUILD_FILE}"
  sed -i -e "s/arch=\".*\"/arch=\""${arch}"\"/" "${APKBUILD_FILE}"
  sed -i -e "s/license=\".*\"/license=\""${license}"\"/" "${APKBUILD_FILE}"

  sed -i -e "s/license=\".*\"/license=\""${license}"\"/" "${APKBUILD_FILE}"
  sed -i -e "s/subpackages=\".*\"/subpackages=\"\"/" "${APKBUILD_FILE}"

  sed -i -e '/^build.*/,$d' "${APKBUILD_FILE}"
  echo "" >>"${APKBUILD_FILE}"
  cat "${PARENT_FOLDER}"/source/build >>"${APKBUILD_FILE}"
  echo "" >>"${APKBUILD_FILE}"
  cat "${PARENT_FOLDER}"/source/check >>"${APKBUILD_FILE}"
  echo "" >>"${APKBUILD_FILE}"
  cat "${PARENT_FOLDER}"/source/package >>"${APKBUILD_FILE}"
  echo "" >>"${APKBUILD_FILE}"

}

main "$@"
