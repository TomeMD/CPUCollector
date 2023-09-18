#!/bin/bash

for cpu_path in /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq; do
    affected_path="${cpu_path/scaling_cur_freq/affected_cpus}"   
    echo $(cat "$affected_path") $(cat "$cpu_path")
    echo ""
done