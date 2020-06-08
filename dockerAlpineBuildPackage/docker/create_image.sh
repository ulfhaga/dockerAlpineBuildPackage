#!/bin/bash
set -e
declare C_DIR=$(dirname "$0")
cd "${C_DIR}" || exit 1

# Build docker image
today=$(date --iso-8601)
docker build  --build-arg BUILD_DATE=${today} --tag=apk-build .

