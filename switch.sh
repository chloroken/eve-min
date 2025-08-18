#!/bin/bash

# Set up directory variables
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
clientlist="$dir/characters.txt"
blocklist="$dir/blocklist.txt"
data="$dir/data"
clientdata="$data/clients.txt"
blockdata="$data/blocks.txt"
cycledata="$data/cycle.txt"

# Initialize magic variables
arglen=${#1}
evesteamid="steam_app_8500"

# Refresh active client list ("r")
if [[ "$1" == r* ]]; then

	# Clean up existing client files
	rm "$clientdata" "$blockdata"

	# Store client IDs of active & blocked characters
	cat "$clientlist" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$clientdata";
	done
	cat "$blocklist" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$blockdata"
	done

	# If this was just a refresh (e.g., "r", not "rf"), stop now
	if [[ $arglen -le 1 ]]; then
		exit
	fi
fi

# Ensure client file exists before continuing
if [ ! -f "$clientdata" ]; then
    exit
fi
mapfile -t clients < "$clientdata"

# Cycle switching ("f", "b")
if [[ "$1" == *f || "$1" == *b ]]; then

	# Read current cycle
	cycle=$(cat "$cycledata")
	target="${clients["$cycle"]}"
	
	# Increment cycle counter
	if [[ "$1" == *f ]]; then ((cycle++));
	elif [[ "$1" == *b ]]; then ((cycle--));
	fi
	
	# Wrap around array bounds
	if [[ "$cycle" -ge "${#clients[@]}" ]]; then ((cycle=0));
	elif [[ "$cycle" -lt 0 ]]; then ((cycle="${#clients[@]}"-1));
	fi
	
	# Save new position in cycle
	echo "$cycle" > "$cycledata"
	
# Targeted switch ("1", "2" etc)
else
	# Refresh switch, trim to target (e.g., drop "r" from r1")
	if [[ "$1" == r* ]]; then
		trimmed=$(echo "$1" | cut -c -f2-)
		target="${clients["$trimmed-1"]}"
		
	# Simple switch, target is arg (e.g., "1", "2")
	else
		target="${clients["$1-1"]}"
	fi
	
	# Prevent out-of-bounds selection
	if [[ "$1" -gt "${#clients[@]}" ]]; then
		exit
	fi
fi

# Activate target client to bring it forward
kdotool windowactivate "$target"

# Read blocked clients
mapfile -t blocks < "$blockdata"

# Look for target with a blocklist
if [ -s "$blockdata" ]; then
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
	
# Look for target (no blocks)
else
	for client in $(kdotool search --classname "$evesteamid")
	do
		# Minimize clients that aren't targeted
		if [[ "$client" != "$target" ]]; then
			kdotool windowminimize "$client"
		fi
	done
fi

# Activate target client again to "ready" mouse
kdotool windowactivate "$target"
