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

main() {
  read_package_name
  ./stop_docker_container.sh
  ./run_docker_container.sh
  docker exec -t -w /home/dev/aports apk-build newapkbuild "${package_name}"
  update_file_apk_build
  create_tarball

  docker exec -t -w /home/dev/aports/"${package_name}" apk-build abuild checksum
  docker exec -t -w /home/dev/aports/"${package_name}" apk-build abuild -r

  printf "The package can be found in folder %s\n" "${PACKAGES}"
  # ./stop_docker_container.sh
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

function update_file_apk_build() {
  # Update file APKBUILD
  APKBUILD_FILE="${A_PORTS}"/"${package_name}"/APKBUILD

  pkg_version=1.0
  sed -i -e "s/pkgver=\"\"/pkgver=\""${pkg_version}"\"/" "${APKBUILD_FILE}"

  sed -i -e 's/source=\"\"/source=\"$pkgname-$pkgver.tar.gz\"/' "${APKBUILD_FILE}"

  pkg_desc="Mydescription"
  sed -i -e "s/pkgdesc=\".*\"/pkgdesc=\""${pkg_desc}"\"/" "${APKBUILD_FILE}"

  url="http:\/\/www.github.com"
  sed -i -e "s/url=\".*\"/url=\""${url}"\"/" "${APKBUILD_FILE}"

  arch="noarch"
  sed -i -e "s/arch=\".*\"/arch=\""${arch}"\"/" "${APKBUILD_FILE}"

  license="LGPL-2.1-or-later"
  sed -i -e "s/license=\".*\"/license=\""${license}"\"/" "${APKBUILD_FILE}"

  sed -i -e "s/license=\".*\"/license=\""${license}"\"/" "${APKBUILD_FILE}"
  sed -i -e "s/subpackages=\".*\"/subpackages=\"\"/" "${APKBUILD_FILE}"

  # function_package="cd \"$builddir\"; mkdir -p $pkgdir;";

  #sed -i -e "s/^package.*/&\n cd \"\$builddir\"; mkdir -p \$pkgdir;/" "${APKBUILD_FILE}"

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
