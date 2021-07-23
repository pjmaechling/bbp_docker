# bbp_docker
tools for evaluating a dockerized version of the SCEC Broadband Platform

bbp_docker: These codes create and run a dockerized version of the python3 version.

The git retrieval command for the starting branch of BBP:
<pre>
  git clone -b 19.8.0-python --single-branch https://github.com/SCECcode/bbp.git
</pre>

## Install inputs
See the wiki page to see list of inputs to bbp install.
https://github.com/pjmaechling/bbp_docker/wiki

## Usage Model

User starts docker on their computer
User start bbp_19_8 container on their computer
In the directory where they started the container, they will use a subdirectory call /target.
The container will read input files, and write results to this directory
$cd /app/target
$ucvm_query -f /app/ucvm/conf/ucvm.conf -m cvmh < /app/test_latlons.txt

Potential Benefits

No installation needed Portable to other computers Progrm requires less space Users could retreieve use remove programs
Potential Limitations

Users must be comfortable running ucvm from a command line interface. This over means they are creating output files, and extracting selected information for plotting.
Users must work within limits of images and local computers. There are some size ucvm problems that won't run on their laptops, so we need to warn people what the limits are.
UCVM is used on supercomputers, for example, to build simulation meshes. The docker version of UCVM may not work for this purpose. There may be a query limit on number of inputs points that an image can query.

## Run Cmd:
docker run --rm -it --mount type=bind,source="$(pwd)"/target,destination=/app/target  sceccode/ucvm_:MMDDHHMM

This is a coding and configuration test for creating a UCVM docker image that can be run on AWS.

## .dockerignore file
There is a .dockerignore file that defines which files not to include in the image. The Dockerfile and this README.md are excluded.

## Build Docker images for Nine SCEC CVMs
The top level script is: build_all.sh which invokes docker build 9 times, one for each model that we distribution in a docker image.
This script moves the model .gz file into the largefiles directory, then runs the build.

## Dockerfile
This lists the steps needed to build the container. It starts with a amazonlinux base image, add compilers and python.

It copies the ucvm git repo from the build computer into the image, and then invokes the build process. The build process runs, installs results in a directory: /app/ucvm

As the docker build concludes, the Dockerfile commands removed the source files, leaving only the binary files and the model files for the selected model.
