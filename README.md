# Docker git repos
*[UCVM Docker Wiki](https://github.com/sceccode/ucvm_docker/wiki)
*[UCVM Docker README.md](https://github.com/pjmaechling/ucvm_docker)
*[BBP Docker](https://github.com/pjmaechling/bbp_docker)
*[BBP Docker Wiki](https://github.com/pjmaechling/bbp_docker/wiki)

# bbp_docker
tools for evaluating a dockerized version of the SCEC Broadband Platform
bbp_docker: These codes create and run a dockerized version of the python3 version.

## Host root
On a mac start at:
/Users/maechlin

## retrieve this repo of bbp docker tools
git clone https://github.com/pjmaechling/bbp_docker.git

## retrieve the desired version of the bbp platform
cd into /Users/maechlin/bbp_docker

The git retrieval command for the starting branch of BBP:
<pre>
  git clone -b 19.8.0-python3 --single-branch https://github.com/SCECcode/bbp.git
</pre>

## Install inputs
This repo contains a file setup_inputs.txt.
This is a list of inputs to the bbp install script.
See the wiki page to see list of inputs to bbp install.
https://github.com/pjmaechling/bbp_docker/wiki

Currently, this is redirected as standardinput to the bbp installation script.

## build.sh script
The docker file is converted to a docker image when this file is run


## Usage Model
User starts docker on their computer
User start bbp_19_8 container on their computer
In the directory where they started the container, they will use a subdirectory call /target.
The container will read input files, and write results to this directory
$cd /app/target
$run_bbp.py

## Potential Benefits

No installation needed Portable to other computers Progrm requires less space Users could retreieve use remove programs
Potential Limitations

Users must be comfortable running ucvm from a command line interface. This over means they are creating output files, and extracting selected information for plotting.
Users must work within limits of images and local computers. There are some size ucvm problems that won't run on their laptops, so we need to warn people what the limits are.


## Run Cmd:
docker run --rm -it --mount type=bind,source="$(pwd)"/target,destination=/app/target  sceccode/bbp_docker:MMDDHHMM

This is a coding and configuration test for creating a UCVM docker image that can be run on AWS.

## .dockerignore file
There is a .dockerignore file that defines which files not to include in the image. The Dockerfile and this README.md are excluded.

## Build Docker images for Nine SCEC CVMs
The top level script is: build_all.sh which invokes docker build 1 time.

## Dockerfile
This lists the steps needed to build the container. It starts with a amazonlinux base image, add compilers and python.

It copies the ucvm git repo from the build computer into the image, and then invokes the build process. The build process runs, installs results in a directory: /app/bbp

## Mount data input output directories
On host system, user invokes docker run. Expectation is that there is a subdirectory call ./target
./target is mounted as /app/bbp_data.
Input files can be stored there.
Output results will be written there
