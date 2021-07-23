# Create bbp docker image
FROM amazonlinux
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
LABEL "maintainer"="Philip Maechling <maechlin@usc.edu>" "appname"="bbp"
#
# Setup path for installation of ucvm into /app/bin
#
#export BBP_DIR=/Users/maechlin/Documents/dev/bbp_2016/16.5.0/bbp
#export BBP_GF_DIR=/Users/maechlin/Documents/dev/bbp_2016/bbp_gf
#export BBP_VAL_DIR=/Users/maechlin/Documents/dev/bbp_2016/bbp_val
#export BBP_DATA_DIR=/Users/maechlin/Documents/dev/bbp_2016/bbp_data
#export PYTHONPATH=$BBP_DIR/comps:$PYTHONPATH


ENV BBP_DIR=/app/bbp BBP_GF_DIR=/app/bbp_gf BBP_VAL_DIR=/app/bbp_val BBP_DATA_DIR=/app/bbp_data
ENV PYTHONPATH=/app/bbp
ENV PATH="/app/bbp/bin:${PATH}"
#
RUN yum install -y make autoconf automake autotools-dev libtool gzip bzip2 gcc gcc-gfortran gcc-c++ which python3
#
WORKDIR /app
COPY ucvm/ ./src
# An external script has posted the correct .gz model file in the largefiles dir
# Install largefiles
WORKDIR /app/src/largefiles
RUN ./stage_large_files.py
WORKDIR /app/src
COPY setup_inputs.txt ./setup_inputs.txt
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
#
# Load the ucvm_plotting library
#
#WORKDIR /app/src
#COPY ucvm_plotting ./plotting
#WORKDIR /app/src/plotting
#RUN yum install -y python-matplotlib
#RUN yum install -y python-basemap
#RUN yum install -y basemap-data-hires.noarch
#RUN ./unpack-dist
#
# start as command line terminal
#
CMD ["/bin/bash"]
