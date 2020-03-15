#!/bin/bash
read -p "Enter the new AKP package name : " package_name
# Create package
./run-docker
docker exec -t -w /home/dev/aports   alpine-build   newapkbuild -c ${package_name}
./stop.sh

