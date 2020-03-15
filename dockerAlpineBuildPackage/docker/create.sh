#!/bin/bash

# Build package
today=$(date --iso-8601)
docker build  --build-arg BUILD_DATE=${today} --tag=alpine-build .

# Create package
docker  exec -t  -w /home/dev/aports   alpine-build   newapkbuild -c packagename

