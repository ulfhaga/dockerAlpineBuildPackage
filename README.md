# TOOLS TO CREATE ALPINE PACKAGE

## Overview
Bash scripts and Docker are used to create an Alpine package. 

## Requirements

Install Docker
https://docs.docker.com/engine/install/
## How to do

### Initialize

Create first a docker image
    
    docker/create_image.sh 
    
### Create a directory with file(s)

Assume your Alpine package name is 'mypackage' and the version is 1.0.
Add the file hello.sh.

    mkdir source/mypackage-1.0
    echo 'echo Hello world!'  > source/mypackage-1.0/hello.sh
 
 
### Add instruction in install scripts source/package    
    
    sed -i -e '/^}/i install -Dm755 hello.sh "$pkgdir"/usr/bin/hello.sh' source/package

### Create package

    docker/create_new_package.sh 

The package is found in folder target.

    