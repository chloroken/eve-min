#!/bin/bash

# Set up directory variables
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
clientlist="$dir/characters.txt"
data="$dir/data"
clientdata="$data/clients.txt"
cycledata="$data/cycle.txt"

# Initialize magic variables
flags="$1"
arglen=${#1}
evesteamid="steam_app_8500" #

# Refresh active client list ("r")
if [[ "$flags" == r* ]]; then

	# Clean up existing client files
	rm "$clientdata"

	# Store client IDs of active & blocked characters
	cat "$clientlist" | while read -r line || [ -n "$line" ]; do
		if [[ "$(kdotool search --name "$line")" ]]; then
			echo "$line" >> "$clientdata"
			echo "$line"
		fi
	done

	# If this was just a refresh (e.g., "r", not "rf"), stop now
	if [ "$flags" == r ]; then
		exit

	# Trim "r" from two-digit flags (e.g., "r1" -> "1", etc.)
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
	
	# Increment cycle counter
	((currentcycle++))
	if [ "$currentcycle" -ge "$clientcount" ]; then
		((currentcycle=0));
	fi
	target="${clients["$currentcycle"]}"
	
	# Save new cycle
	echo "$currentcycle" > "$cycledata"

# Backward cycle target selection ("b")
elif [ "$flags" == b ]; then

	# Get target window based on cycle
	currentcycle=$(cat "$cycledata")
	# Increment cycle counter
	((currentcycle--))
	if [ "$currentcycle" -lt 0 ]; then
		((currentcycle="$clientcount"-1));
	fi
	target="${clients["$currentcycle"]}"
	
	
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

# Use kwin to access dbus for fastest switching
script=$(mktemp)
sed "s/\$TARGET/$target/" $(dirname $0)/switch.js > $script
script_id=$(qdbus org.kde.KWin /Scripting loadScript $script)
qdbus org.kde.KWin /Scripting/Script$script_id run
qdbus org.kde.KWin /Scripting/Script$script_id stop
