# TOOLS TO CREATE ALPINE PACKAGE

## Overview
[Bash](https://www.gnu.org/software/bash/) scripts and [Docker](https://www.docker.com/) are used to create an [Alpine](https://alpinelinux.org/) package. 
Any files can be added to the package.

## Requirements

Install Docker
https://docs.docker.com/engine/install/
## How to do

### Initialize

Create first a docker image

    cd dockerAlpineBuildPackage;
    docker/create_image.sh; 

To change package version number e.g. edit file source/globals. 
    
### Create a directory with file(s)

Assume that the Alpine package will have the name 'mypackage' and the version is 1.0.
In this simple example there is only one file with the name hello.sh that will be in the package.

    mkdir source/mypackage-1.0;
    echo 'echo Hello world!'  > source/mypackage-1.0/hello.sh;
 
### Add instructions in install scripts source/package    

With this example we add the script: 

install -Dm755 hello.sh "$pkgdir"/usr/bin/hello.sh
in function package(). The folder /usr/bin will contain the file hello.sh.
    
    sed -i -e '/^}/i install -Dm755 hello.sh "$pkgdir"/usr/bin/hello.sh' source/package;

### Create package

    docker/create_new_package.sh; 
    
Enter the name mypackage    

The package is found in folder target 
(target/packages/aports/x86_64/mypackage-1.0-r0.apk).
In an Alpine Linux distribution run 
   
    sudo apk add mypackage-1.0-r0.apk;
    # Test by typeing 
    hello.sh

## Configuration

Configuration can be done by change the parameters in folder docker/globals.  

## References

| Title      | Link |
| ----------- | ----------- |
| Creating an Alpine package       | https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package       |
  