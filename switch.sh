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
flags="$1"
arglen=${#1}
evesteamid="steam_app_8500" # steam
#evesteamid="steam_app_default" # lutris

# Refresh active client list ("r")
if [[ "$flags" == r* ]]; then

	# Clean up existing client files
	rm "$clientdata" "$blockdata"

	# Store client IDs of active & blocked characters
	cat "$clientlist" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$clientdata"
	done
	cat "$blocklist" | while read -r line || [ -n "$line" ]; do
		kdotool search --name "$line" >> "$blockdata"
	done

	# If this was just a refresh (e.g., "r", not "rf"), stop now
	if [ "$flags" == r ]; then
		exit

	# Trim two-digit flags (e.g., "r1" or "rb" -> "1" or "b", etc.)
	else
		flags=$(echo "$1" | cut -c 2-)
	fi
fi

# Minimize all clients ("m")
if [ "$flags" == m ]; then
	for client in $(kdotool search --classname "$evesteamid")
	do
		kdotool windowminimize "$client"
	done
	exit
fi

# Kill all clients ("k")
if [ "$flags" == k ]; then
	for client in $(kdotool search --classname "$evesteamid")
	do
		pkill "exefile.exe"
	done
	exit
fi

# Ensure client file exists before continuing
if [ ! -f "$clientdata" ]; then
    exit
fi

# Map client data to a temporary array
mapfile -t clients < "$clientdata"
clientcount="${#clients[@]}"

# Forward cycle target selection ("f")
if [ "$flags" == f ]; then

	# Get target window based on cycle
	currentcycle=$(cat "$cycledata")
	target="${clients["$currentcycle"]}"
	
	# Increment cycle counter
	((currentcycle++))
	if [ "$currentcycle" -ge "$clientcount" ]; then
		((currentcycle=0));
	fi
	
	# Save new cycle
	echo "$currentcycle" > "$cycledata"

# Backward cycle target selection ("b")
elif [ "$flags" == b ]; then

	# Get target window based on cycle
	currentcycle=$(cat "$cycledata")
	target="${clients["$currentcycle"]}"
	
	# Increment cycle counter
	((currentcycle--))
	if [ "$currentcycle" -lt 0 ]; then
		((currentcycle="$clientcount"-1));
	fi
	
	# Save new cycle
	echo "$currentcycle" > "$cycledata"
	
# Specific index target selection ("#")
else

	# Prevent out-of-bounds selection
	if [ "$flags" -gt "$clientcount" ]; then
		exit
	fi
	target="${clients["$flags-1"]}"
fi

# Activate target client to bring it forward
kdotool windowactivate "$target"

# Switch (with blocks)
if [ -s "$blockdata" ]; then
	mapfile -t blocks < "$blockdata"
	for client in $(kdotool search --classname "$evesteamid")
	do
		# Look through blocklist
		for block in "${blocks[@]}"
		do
			# Minimize clients that aren't blocked or targeted
			if [ "$client" != "$block" ]; then
				if [ "$client" != "$target" ]; then
					kdotool windowminimize "$client"
				fi
			fi
		done
	done
	
# Switch (without blocks)
else
	for client in $(kdotool search --classname "$evesteamid")
	do
		# Minimize clients that aren't targeted
		if [ "$client" != "$target" ]; then
			kdotool windowminimize "$client"
		fi
	done
fi

# Activate target client again to "ready" mouse
kdotool windowactivate "$target"
