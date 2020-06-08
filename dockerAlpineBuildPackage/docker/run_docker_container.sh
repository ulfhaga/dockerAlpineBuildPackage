#!/bin/bash
set -x
declare -r parent_folder=$(dirname "$(pwd)")
declare -r aports=${parent_folder}/target/aports
declare -r packages=${parent_folder}/target/packages

main() {
  if [[ ! -d "${aports}" ]]; then
    mkdir -p "${aports}"
  fi

  if [[ ! -d "${packages}" ]]; then
    mkdir -p "${packages}"
  fi

  docker run --rm -dit --env DISPLAY=":0" \
    --mount type=bind,src=${aports},dst=/home/dev/aports,bind-propagation=shared \
    --mount type=bind,src=${packages},dst=/home/dev/packages,bind-propagation=shared \
    --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix --name apk-build apk-build:latest
}
main "$@"
