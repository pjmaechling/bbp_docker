# Create bbp docker image
FROM amazonlinux
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
LABEL "maintainer"="Philip Maechling <maechlin@usc.edu>" "appname"="bbp"
#
# Setup path for installation of ucvm into /app/bin
#

ENV BBP_DIR=/app/bbp/bbp BBP_GF_DIR=/app/bbp_gf BBP_VAL_DIR=/app/bbp_val BBP_DATA_DIR=/app/bbp_data
ENV PYTHONPATH=/app/bbp/bbp/comps
ENV PATH="/app/bbp/bbp/comps:/app/bbp/bbp/utils/batch:${PATH}"
#
RUN yum install -y make autoconf automake autotools-dev libtool gzip bzip2 gcc gcc-gfortran gcc-c++ which python3
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
WORKDIR /app/src
RUN ./ucvm_setup.py -a -d < setup_inputs.txt
#
# Remove the src directories to save space
#
WORKDIR /app
RUN rm -rf src
#
# Define file input/output mounted disk
#
VOLUME /app/target
#
# Setup user with test input files
#
WORKDIR /app
COPY test_latlons.txt ./test_latlons.txt
COPY basic_query.txt ./basic_query.txt
#
# Define directory that will be mounted and used for file input/output
#
WORKDIR /app/target
COPY test_latlons.txt ./test_latlons.txt
COPY basic_query.txt ./basic_query.txt
#
# start as command line terminal
#
CMD ["/bin/bash"]
