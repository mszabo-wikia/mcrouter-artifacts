#!/bin/bash

# Main containerized mcrouter build script.

set -ex

mkdir -p fbcode-scratch

# Add a non-privileged user for building and testing.
# Some tests in particular assume a non-root user.
useradd --system --no-create-home --home /nonexistent \
	--user-group --comment "mcrouter user" mcrouter

chown -R mcrouter:mcrouter mcrouter fbcode-scratch

cd mcrouter

PACKAGE_VERSION="$(date +%Y%m%d)-$(sudo -u mcrouter git rev-parse --short HEAD)"

./build/fbcode_builder/getdeps.py --allow-system-packages install-system-deps --recursive mcrouter

sudo -u mcrouter ./build/fbcode_builder/getdeps.py --allow-system-packages --scratch-path ../fbcode-scratch build --src-dir=. mcrouter

sudo -u mcrouter ./build/fbcode_builder/getdeps.py --allow-system-packages --scratch-path ../fbcode-scratch test --src-dir=. mcrouter

cd ../fbcode-scratch/build/mcrouter

source /etc/os-release

CPACK_SHARED_ARGS=(
	-D CPACK_PACKAGE_NAME=mcrouter
	-D CPACK_PACKAGE_VENDOR="https://github.com/mszabo-wikia/mcrouter-artifacts"
	-D CPACK_PACKAGE_VERSION="$PACKAGE_VERSION"
	-D CPACK_PACKAGE_DESCRIPTION_SUMMARY="A memcached protocol router for scaling memcached deployments."
	-D CPACK_PACKAGE_CONTACT="mszabo-oss@protonmail.com"
	-D CPACK_STRIP_FILES=ON
)

if [ "$ID" == "debian" ]; then
	cpack -G DEB \
		-D CPACK_DEBIAN_FILE_NAME=mcrouter.deb \
		-D CPACK_DEBIAN_PACKAGE_HOMEPAGE="https://github.com/mszabo-wikia/mcrouter-artifacts" \
		-D CPACK_DEBIAN_PACKAGE_MAINTAINER="Máté Szabó <mszabo-oss@protonmail.com>" \
		-D CPACK_DEBIAN_PACKAGE_VERSION="$PACKAGE_VERSION" \
		-D CPACK_DEBIAN_PACKAGE_SHLIBDEPS=ON \
		"${CPACK_SHARED_ARGS[@]}"
else
	echo "Unsupported distribution: $ID"
	exit 1
fi
