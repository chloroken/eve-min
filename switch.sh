#!/bin/bash

# Set up directory variables
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
data="$dir/data"
clientlist="$data/clientlist.txt"
blocklist="$data/blocklist.txt"
clients="$data/clients.txt"
blocks="$data/blocks.txt"
# Initialize magic variables
arglen=${#1}
evesteamid="steam_app_8500"

# Refresh active client list ("r")
if [[ "$1" == r* ]]; then

	# Clean up existing client files
	rm "$clients" "$blocks"

	# Store client IDs of active & blocked characters
	cat "$clientlist" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$clients";
	done
	cat "$blocklist" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$blocks"
	done

	# If this was just a refresh (e.g., "r", not "rf"), stop now
	if [[ $arglen -le 1 ]]; then
		exit
	fi
fi

# Ensure client file exists before continuing
if [ ! -f "$clients" ]; then
	echo 'No client list! Try running ./switch.sh "r" to refresh PIDs.'
    exit
fi

# Cycled switching ("f", "b")
mapfile -t clients < "$data/clients.txt"
if [[ "$1" == *f || "$1" == *b ]]; then

	# Read current cycle
	cycle=$(cat "$data/cycle.txt")
	target="${clients["$cycle"]}"
	
	# Increment cycle counter
	if [[ "$1" == *f ]]; then ((cycle++));
	elif [[ "$1" == *b ]]; then ((cycle--));
	fi
	
	# Wrap around when bounds are hit
	if [[ "$cycle" -ge "${#clients[@]}" ]]; then ((cycle=0));
	elif [[ "$cycle" -lt 0 ]]; then ((cycle="${#clients[@]}"-1));
	fi

	# Save new position in cycle
	echo "$cycle" > "$data/cycle.txt"
	
# Targeted switch ("1", "2" etc)
else

	# Simple switch, target is argument (e.g., "1", "2")
	if [[ $arglen -le 1 ]]; then
		target="${clients["$1-1"]}"
		
	# Refreshing switch, target is trimmed (e.g., drop "r" from r1")
	else
		trimmed=$(echo "$1" | cut -c -f2-)
		target="${clients["$trimmed-1"]}"
	fi

	# Prevent out-of-bounds selection
	if [[ "$1" -gt "${#clients[@]}" ]]; then
		exit
	fi
fi

# Activate target client to bring it forward
kdotool windowactivate "$target"

# Read blocked clients
mapfile -t blocks < "$data/blocks.txt"

# Look through active EVE clients
for client in $(kdotool search --classname "$evesteamid")
do
	# Look through blocklist
	for block in "${blocks[@]}"
	do
		# Minimize clients that aren't blocked or targeted
		if [[ "$client" != "$block" && "$client" != "$target" ]]; then
			kdotool windowminimize "$client"
		fi
	done
done

# Activate target client again to "ready" mouse
kdotool windowactivate "$target"
