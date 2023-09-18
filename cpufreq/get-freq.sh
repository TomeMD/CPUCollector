#!/bin/bash

export HOME=`dirname $0`

while true; do
    # Get active cores
    OUTPUT=$(mpstat -P ALL 1 1 | grep "Average" | tail -n +3 | awk '$NF < 90 {print $2}')
    CORES=""
    for CORE in $OUTPUT; do
        if [[ -z "$CORES" ]]; then
            CORES="${CORE}"
        else
            CORES="${CORES},${CORE}"
        fi
    done

    CORE_PATTERN=$(echo $CORES | sed 's/,/\|/g')
    OUTPUT=$(${HOME}/get-freq-percore.sh | egrep "^($CORE_PATTERN) ")

    SUM=0
    COUNT=0
    # Get average frequency from active cores
    while read -r line; do
        FREQ=$(echo $line | awk '{print $2}')
        SUM=$((SUM + FREQ))
        COUNT=$((COUNT + 1))
    done <<< "$OUTPUT"

    AVERAGE=$((SUM / COUNT))
    AVERAGE_MHZ=$((AVERAGE / 1000))
    TIMESTAMP=$(date +%s%N)
    DATA="cpu_frequency average=${AVERAGE_MHZ},count=${COUNT} ${TIMESTAMP}"
    curl -i -XPOST "http://montoxo.des.udc.es:8086/api/v2/write?org=MyOrg&bucket=glances" --header "Authorization: Token MyToken" --data-binary "${DATA}" > /dev/null 2>&1
done