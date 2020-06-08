#!/bin/bash
#
# NAME
#      clean.sh - Clean up files and stop docker containers.
# SYNOPSIS
#     clean.sh
#
set -e
declare C_DIR=$(dirname "$0")
cd "${C_DIR}" || exit 1
./stop_docker_container.sh
docker image rm  apk-build:latest
rm -fr ../target
