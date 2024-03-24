#!/usr/bin/env bash

INPUT="${1}"

printf "Count\tAvg, s\tMin, s\tMax, s\n"
count=0
total=0
min=1
max=0
while read num; do
	total=$(echo "scale=10; ${total} + ${num}" | bc)
	if [ 1 -eq "$(echo "scale=10; ${num} < ${min}" | bc)" ]; then  
		min="${num}"
	fi
        if [ 1 -eq "$(echo "scale=10; ${num} > ${max}" | bc)" ]; then  
		max="${num}"
	fi
	count=$((count + 1))
done < <(tshark -r "${INPUT}" -Tfields -e "tcp.analysis.ack_rtt" | sed '/^\s*$/d' -)
avg=$(echo "scale=10; ${total} / ${count}" | bc)
printf "%zu\t%lf\t%lf\t%lf\n" "$count" "$avg" "$min" "$max"

