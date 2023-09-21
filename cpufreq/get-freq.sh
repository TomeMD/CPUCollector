#!/bin/bash

while true; do
    # Get active cores
    ACTIVE_CORES=$(mpstat -P ALL 1 1 | awk '/Average|Media/ && $2 !~ /^(CPU|all)$/ && $NF < 50 {print $2}')

    if [ -z "$ACTIVE_CORES" ]; then
        continue
    fi

    # Get average frequency from active cores
    SUM=0
    COUNT=0
    for CORE in ${ACTIVE_CORES[@]}; do
        FREQ=$(<"/sys/devices/system/cpu/cpu${CORE}/cpufreq/scaling_cur_freq")
        SUM=$((SUM + FREQ))
        COUNT=$((COUNT + 1))
    done

    AVERAGE=$((SUM / COUNT / 1000))

    # Send data to InfluxDB
    TIMESTAMP=$(date +%s%N)
    DATA="cpu_frequency average=${AVERAGE},count=${COUNT} ${TIMESTAMP}"
    curl -s -XPOST "http://montoxo.des.udc.es:8086/api/v2/write?org=MyOrg&bucket=glances" --header "Authorization: Token MyToken" --data-binary "${DATA}"
done