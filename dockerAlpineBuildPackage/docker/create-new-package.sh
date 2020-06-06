#!/bin/sh

read -r -p "Enter the new AKP package name : " package_name
# Create package
./stop.sh
./run-docker
pkg_desc="Mydescription"
docker exec -t -w /home/dev/aports apk-build newapkbuild ${package_name}


# Update file /etc/abuild.conf

set -x

# Update file APKBUILD

pkg_version=1.0
sed -i -e "s/pkgver=\"\"/pkgver=\""${pkg_version}"\"/" ../aports/"${package_name}"/APKBUILD

sed -i -e 's/source=\"\"/source=\"$pkgname-$pkgver.tar.gz\"/' ../aports/"${package_name}"/APKBUILD

APKBUILD_FILE="../aports/"${package_name}"/APKBUILD"

pkg_desc="Mydescription"
sed -i -e "s/pkgdesc=\".*\"/pkgdesc=\""${pkg_desc}"\"/"  ../aports/"${package_name}"/APKBUILD

url="http:\/\/www.github.com"
sed -i -e "s/url=\".*\"/url=\""${url}"\"/"  ../aports/"${package_name}"/APKBUILD

license="LGPL-2.1-or-later";
sed -i -e "s/license=\".*\"/license=\""${license}"\"/"  ../aports/"${package_name}"/APKBUILD

sed -i -e "s/license=\".*\"/license=\""${license}"\"/"  ../aports/"${package_name}"/APKBUILD

sed -i -e "s/subpackages=\".*\"/subpackages=\"\"/"  "${APKBUILD_FILE}"

# function_package="cd \"$builddir\"; mkdir -p $pkgdir;";

sed -i -e "s/^package.*/&\n cd \"\$builddir\"; mkdir -p \$pkgdir;/" "${APKBUILD_FILE}"


# Add tar ball
tarball=test-1.0.tar.gz;
tar -cvzf ${tarball} -C ../source test-1.0
cp ${tarball} ../aports/${package_name}

# mkdir -p ../aports/"${package_name}"/pkg/test
# mkdir -p ../aports/"${package_name}"/pkg/test-dev

./stop.sh

