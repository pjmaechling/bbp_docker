# Create bbp docker image
FROM amazonlinux
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
LABEL "maintainer"="Philip Maechling <maechlin@usc.edu>" "appname"="bbp"
#
# Setup path for installation of bbp into /app/bbp
# Assume the data directory is a external bind mount, so that the results are saved
# Also assume the user treats the /app/target directory as their working directory
#

ENV BBP_DIR=/app/bbp/bbp BBP_GF_DIR=/app/bbp_gf BBP_VAL_DIR=/app/bbp_val BBP_DATA_DIR=/app/target BASEBBP=/app/bbp/bbp BBPDIR=/app/bbp SRCDIR=/app/bbp/bbp/src MD5FILE=/app/bbp/setup/bbp-19.4.0-md5.txt
ENV PYTHONPATH=/app/bbp/bbp/comps
ENV PATH="/app/bbp/bbp/comps:/app/bbp/bbp/utils/batch:${PATH}"
#
RUN yum -y update 
RUN yum -y install yum-utils
RUN yum -y groupinstall "Development Tools"
# this includes autoconf automake, gcc gcc-c++ make libtool
RUN yum install -y util-linux pip curl which autotools-dev gzip bzip2 gcc-gfortran
RUN yum -y install python3
RUN yum -y install python3-pip
RUN pip install -U pip
RUN pip install numpy scipy pyproj matplotlib
#
WORKDIR /app
COPY bbp/ ./bbp
# Run the bbp install script
# The setup_inputs is a list of command line prompts for region
# This setup is configured and saved in the git repo.
# To start, the config says yes to install all regions, but could be minimized later
WORKDIR /app/bbp/setup
COPY setup_inputs.txt ./setup_inputs.txt
RUN ./easy_install_bbp_19.4.0.sh < setup_inputs.txt
#
# Define file input/output mounted disk
#
VOLUME /app/target
#
# Setup user with test input files
# Correct this. This input isn't needed
WORKDIR /app/target
COPY setup_inputs.txt ./setup_inputs.txt
#
# start as command line terminal
#
CMD ["/bin/bash"]
