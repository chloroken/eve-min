#!/bin/bash

# Locate current working directory
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
pids="$dir/data/pids.txt"
blocks="$dir/data/bpids.txt"

# EVE's steam ID string
evesteamid="steam_app_8500"

# Refresh PIDs ("r")
if [[ "$1" == r* ]]; then
	# Clean up existing PID files
	rm "$pids"
	rm "$blocks"

	# Store PIDs of active & blocked characters
	cat "$dir/charlist.txt" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$pids"
	done
	cat "$dir/blocklist.txt" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$blocks"
	done

	# If this was just a refresh call, stop now
	if [[ "$1" == "r" ]]; then
		exit
	fi
fi

# Ensure a PIDs file exists before continuing
if [ ! -f "$pids" ]; then
	echo 'No PIDs! Try running ./switch.sh "r" to refresh PIDs.'
    exit
fi

# Cycled switching ("f", "b")
mapfile -t pids < "$dir/data/pids.txt"
if [[ "$1" == *f || "$1" == *b ]]; then
	# Read current cycle
	cycle=$(cat "$dir/data/cycle.txt")
	tar="${pids["$cycle"]}"
	
	# Increment cycle counter
	if [[ "$1" == *f ]]; then ((cycle++));
	elif [[ "$1" == *b ]]; then ((cycle--));
	fi
	
	# Wrap around when bounds are hit
	if [[ "$cycle" -ge "${#pids[@]}" ]]; then ((cycle=0));
	elif [[ "$cycle" -lt 0 ]]; then ((cycle="${#pids[@]}"-1));
	fi

	# Save new position in cycle
	echo "$cycle" > "$dir/data/cycle.txt"
	
# Targeted switch ("1", "2" etc)
else
	# Trim argument to find target
	length="$1"
	if [[ ${#length} -le 1 ]]; then
		echo "Easy"
		tar="${pids["$1-1"]}"
	else
		trimmed=$(echo "$1"| cut -c 2)
		tar="${pids["$trimmed-1"]}"
	fi
	
	# Prevent out-of-bounds selection
	if [[ "$1" -gt "${#pids[@]}" ]]; then
		exit
	fi
fi

# Activate target to bring it forward
kdotool windowactivate "$tar"

# Read blocked PIDs
mapfile -t blocks < "$dir/data/bpids.txt"

# Look through EVE clients
for pid in $(kdotool search --classname "$evesteamid")
do
	# Look through blocklist
	for block in "${blocks[@]}"
	do
		# Minimize clients that aren't blocked or targeted
		if [[ "$pid" != "$block" && "$pid" != "$tar" ]]; then
			kdotool windowminimize "$pid"
		fi
	done
done

# Activate target again to "ready" mouse
kdotool windowactivate "$tar"
