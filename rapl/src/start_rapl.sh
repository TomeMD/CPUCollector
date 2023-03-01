#!/bin/sh

export LD_LIBRARY_PATH=/usr/local/lib

echo "Starting RAPL monitor"
/tmp/rapl_plot ${RAPL_OUTPUT_PREFIX} ${RAPL_SECONDS_INTERVAL}