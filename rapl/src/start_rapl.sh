#!/bin/sh

export LD_LIBRARY_PATH=/usr/local/lib

chmod 666 /dev/cpu/*/msr
echo 0 > /proc/sys/kernel/perf_event_paranoid

cp /var/lib/rapl/rapl_plot/rapl_plot /tmp/rapl_plot

setcap cap_sys_rawio=ep /tmp/rapl_plot

echo "Starting RAPL monitor"
/tmp/rapl_plot ${RAPL_OUTPUT_PREFIX} ${RAPL_SECONDS_INTERVAL}