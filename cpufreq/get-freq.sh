#!/bin/bash

TOTAL_CORES=$(lscpu | grep -m 1 "CPU(s):" | awk '{print $2}')
declare -A CORE_DICT

while true; do
    # Get active cores
    ACTIVE_CORES=$(mpstat -P ALL 1 1 | awk '/Average|Media/ && $2 !~ /^(CPU|all)$/ && ($NF + 0) < 50 {print $2}')
    for CORE in $ACTIVE_CORES; do
      CORE_DICT[$CORE]=1
    done

    SUM=0
    ACTIVE_SUM=0
    ACTIVE_COUNT=0
    for ((i=0; i < TOTAL_CORES; i++)); do
      FREQ=$(<"/sys/devices/system/cpu/cpu${i}/cpufreq/scaling_cur_freq")
      SUM=$((SUM + FREQ))
      if [[ ${CORE_DICT[$i]} -eq 1 ]]; then
        ACTIVE_SUM=$((ACTIVE_SUM + FREQ))
        ACTIVE_COUNT=$((ACTIVE_COUNT + 1))
	      CORE_DICT[$i]=0
      fi
    done

    AVERAGE=$((SUM / TOTAL_CORES/ 1000))
    if [[ ACTIVE_COUNT -ne 0 ]]; then
      ACTIVE_AVERAGE=$((ACTIVE_SUM / ACTIVE_COUNT / 1000))
    else
      ACTIVE_AVERAGE=0
    fi

    # Send data to InfluxDB
    TIMESTAMP=$(date +%s%N)
    DATA="cpu_frequency mpstat_average=${ACTIVE_AVERAGE},mpstat_sum=${ACTIVE_SUM},mpstat_count=${ACTIVE_COUNT},total_average=${AVERAGE} ${TIMESTAMP}"
    curl -s -XPOST "http://montoxo.des.udc.es:8086/api/v2/write?org=MyOrg&bucket=glances" --header "Authorization: Token MyToken" --data-binary "${DATA}"
done