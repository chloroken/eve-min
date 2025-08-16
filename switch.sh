#!/bin/bash

# Locate current working directory
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Refresh PIDs
if [[ "$1" == "r" ]]; then

	# Clean up existing PID files
	pids="$dir/pids.txt"
	rm "$pids"
	blocks="$dir/bpids.txt"
	rm "$blocks"

	# Store PIDs of active characters
	cat "$dir/charlist.txt" | while read -r line || [ -n "$line" ]; do
		$dir/kdotool search --name "$line" >> "$pids"
	done

	# Store PIDs of blocked characters
	cat "$dir/blocklist.txt" | while read -r line || [ -n "$line" ]; do
		$dir/kdotool search --name "$line" >> "$blocks"
	done

	exit
fi

# Get a target to switch to
mapfile -t pids < "$dir/pids.txt"
if [[ "$1" == "f" || "$1" == "b" ]]; then

	# Cycle switch
	cycle=$(cat "$dir/cycle.txt")
	tar="${pids["$cycle"]}"
	
	# Increment forward
	if [[ "$1" == "f" ]]; then ((cycle++));
	# Increment backward
	elif [[ "$1" == "b" ]]; then ((cycle--));
	fi
	
	# Wrap around when bounds are hit
	if [[ "$cycle" -ge "${#pids[@]}" ]]; then ((cycle=0));
	elif [[ "$cycle" -lt 0 ]]; then ((cycle="${#pids[@]}"-1));
	fi

	# Save new position in cycle
	echo "$cycle" > "$dir/cycle.txt"
else
	# Targeted switch
	tar="${pids["$1-1"]}"
	
	# Prevent out-of-bounds selection
	if [[ "$1" -gt "${#pids[@]}" ]]; then
		exit
	fi
fi

# Activate target to bring it forward
$dir/kdotool windowactivate "$tar"

# Read blocked PIDs
mapfile -t blocks < "$dir/bpids.txt"

# EVE's steam ID string
evesteamid="steam_app_8500"

# Look through EVE clients
for pid in $($dir/kdotool search --classname "$evesteamid")
do
	# Look through blocklist
	for block in "${blocks[@]}"
	do
		# Minimize clients that aren't blocked or targeted
		if [[ "$pid" != "$block" && "$pid" != "$tar" ]]; then
			$dir/kdotool windowminimize "$pid"
		fi
	done
done

# Activate target again to "ready" mouse
$dir/kdotool windowactivate "$tar"
