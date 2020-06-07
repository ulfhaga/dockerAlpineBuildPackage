#!/bin/bash
set -e
source global
echo ${tt}
declare -r PARENT_FOLDER=$(dirname "$(pwd)")
declare -r A_PORTS=${PARENT_FOLDER}/target/aports
declare -r PACKAGES=${PARENT_FOLDER}/target/packages

read -r -p "Enter the new AKP package name : " package_name

if [[ -d "${A_PORTS}"/"${package_name}" ]]; then
  rm -fr "${A_PORTS}"/"${package_name}"
fi

# Create package
set +e
./stop.sh
set -e
./run-docker
pkg_desc="Mydescription"
docker exec -t -w /home/dev/aports apk-build newapkbuild "${package_name}"

# Update file /etc/abuild.conf

# Update file APKBUILD
APKBUILD_FILE="${A_PORTS}"/"${package_name}"/APKBUILD

pkg_version=1.0
sed -i -e "s/pkgver=\"\"/pkgver=\""${pkg_version}"\"/" "${APKBUILD_FILE}"

sed -i -e 's/source=\"\"/source=\"$pkgname-$pkgver.tar.gz\"/' "${APKBUILD_FILE}"

pkg_desc="Mydescription"
sed -i -e "s/pkgdesc=\".*\"/pkgdesc=\""${pkg_desc}"\"/" "${APKBUILD_FILE}"

url="http:\/\/www.github.com"
sed -i -e "s/url=\".*\"/url=\""${url}"\"/" "${APKBUILD_FILE}"

license="LGPL-2.1-or-later"
sed -i -e "s/license=\".*\"/license=\""${license}"\"/" "${APKBUILD_FILE}"

sed -i -e "s/license=\".*\"/license=\""${license}"\"/" "${APKBUILD_FILE}"
sed -i -e "s/subpackages=\".*\"/subpackages=\"\"/" "${APKBUILD_FILE}"

# function_package="cd \"$builddir\"; mkdir -p $pkgdir;";

#sed -i -e "s/^package.*/&\n cd \"\$builddir\"; mkdir -p \$pkgdir;/" "${APKBUILD_FILE}"


sed -i -e '/^build.*/,$d' "${APKBUILD_FILE}"
echo "" >> "${APKBUILD_FILE}"
cat "${PARENT_FOLDER}"/source/build >> "${APKBUILD_FILE}"
echo "" >> "${APKBUILD_FILE}"
cat "${PARENT_FOLDER}"/source/check >> "${APKBUILD_FILE}"
echo "" >> "${APKBUILD_FILE}"
cat "${PARENT_FOLDER}"/source/package >> "${APKBUILD_FILE}"
echo "" >> "${APKBUILD_FILE}"


# Create tarball
tar_ball_root_dir="${package_name}"-"${pkg_version}"
tarball_directory="${PARENT_FOLDER}"/source/"${tar_ball_root_dir}"
tarball="${tarball_directory}".tar.gz

if [[ -f "${tarball_directory}" ]]; then
  printf "ERROR: The files for creating a tarball %s is missing. \n " "${tarball}"
  printf "Use the script ../source/create-source.sh to create one.\n"
  exit 1;
else
  set -x
  tar -cvzf "${tarball}" -C "${PARENT_FOLDER}"/source "${tar_ball_root_dir}"
  mv "${tarball}" "${A_PORTS}"/"${package_name}"
fi

docker exec -t -w /home/dev/aports/"${package_name}" apk-build abuild checksum
docker exec -t -w /home/dev/aports/"${package_name}" apk-build abuild -r

printf "The package can be found in folder %s\n"  "${PACKAGES}"
# ./stop.sh
