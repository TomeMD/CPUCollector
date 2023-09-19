#!/bin/bash

export HOME=`dirname $0`

while true; do
    # Get active cores
    ACTIVE_CORES=$(mpstat -P ALL 1 1 | grep "Average" | tail -n +3 | awk '$NF < 50 {print $2}')
    readarray -t ACTIVE_CORES_ARRAY <<< "$ACTIVE_CORES"

    # Get average frequency from active cores
    SUM=0
    COUNT=0
    for CORE in "${ACTIVE_CORES_ARRAY[@]}"; do 
        FREQ=$(cat "/sys/devices/system/cpu/cpu${CORE}/cpufreq/scaling_cur_freq")
        SUM=$((SUM + FREQ))
        COUNT=$((COUNT + 1))
    done
    AVERAGE=$((SUM / COUNT))
    AVERAGE_MHZ=$((AVERAGE / 1000))

    # Send data to InfluxDB
    TIMESTAMP=$(date +%s%N)
    DATA="cpu_frequency average=${AVERAGE_MHZ},count=${COUNT} ${TIMESTAMP}"
    curl -i -XPOST "http://montoxo.des.udc.es:8086/api/v2/write?org=MyOrg&bucket=glances" --header "Authorization: Token MyToken" --data-binary "${DATA}" > /dev/null 2>&1
done