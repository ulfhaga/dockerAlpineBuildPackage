#!/bin/sh

read -r -p "Enter the new AKP package name : " package_name
# Create package
./stop.sh
./run-docker
pkg_desc="Mydescription"
docker exec -t -w /home/dev/aports apk-build newapkbuild ${package_name}

# Add tar ball
tarball=software-1.0.tar;
tar -cvf ${tarball} -C ../source hello.sh

 # Update file /etc/abuild.conf
 set -x
sed -i -e "s/source=\"\"/source=\""${tarball}"\"/" ../aports/"${package_name}"/APKBUILD

pkg_version=1.0
sed -i -e "s/pkgver=\"\"/pkgver=\""${pkg_version}"\"/" ../aports/"${package_name}"/APKBUILD

pkg_desc="Mydescription"
sed -i -e "s/pkgdesc=\"\"/pkgdesc=\""${pkg_desc}"\"/"  ../aports/"${package_name}"/APKBUILD

url="www.github.com"
sed -i -e "s/url=\"\"/url=\""${url}"\"/"  ../aports/"${package_name}"/APKBUILD

license="LGPL-2.1-or-later";
sed -i -e "s/license=\"\"/license=\""${license}"\"/"  ../aports/"${package_name}"/APKBUILD

sed -i -e "s/license=\"\"/license=\""${license}"\"/"  ../aports/"${package_name}"/APKBUILD

cp ${tarball} ../aports/${package_name}

mkdir -p ../aports/"${package_name}"/pkg/test
mkdir -p ../aports/"${package_name}"/pkg/test-dev

./stop.sh

