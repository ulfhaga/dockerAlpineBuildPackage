#!/bin/bash

# Build docker image
today=$(date --iso-8601)
docker build  --build-arg BUILD_DATE=${today} --tag=apk-build .

