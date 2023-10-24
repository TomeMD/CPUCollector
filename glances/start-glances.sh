#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Error: Missing some arguments."
  echo "Usage: $0 <INFLUXDB_HOST> <INFLUXDB__BUCKET>."
fi
INFLUXDB_HOST=$1
INFLUXDB_BUCKET=$2
sed -i "/\[influxdb2\]/,/\[/{/^host=/s/.*/host=${INFLUXDB_HOST}/}" /etc/glances.conf
sed -i "/\[influxdb2\]/,/\[/{/^bucket=/s/.*/bucket=${INFLUXDB_BUCKET}/}" /etc/glances.conf
cd /app
/venv/bin/python3 -m glances -C /etc/glances.conf $GLANCES_OPT