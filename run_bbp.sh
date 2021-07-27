#!/bin/sh
docker run --rm -it --mount type=bind,source="$(pwd)"/target,destination=/app/target bbp_python3:07261745
