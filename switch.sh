#!/bin/bash

# Set up directory variables
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
clientlist="$dir/characters.txt"
data="$dir/data"
clientdata="$data/clients.txt"
cycledata="$data/cycle.txt"

# Initialize magic variables
flags="$1" # makes code more readable
windowclass="steam_app_8500" # use steam_app_default for lutris

# Refresh active client list ("r")
if [[ "$flags" == r* ]]; then

	# Clean up existing client files
	rm "$clientdata"

	# Store client IDs of active characters
	cat "$clientlist" | while read -r line || [ -n "$line" ]; do

		# Use kdotool to check if a specific client is active
		if [[ "$(kdotool search --name "$line")" ]]; then
		
			# Save client's "kwin identifier" to clientdata
			echo $(kdotool search --name "$line") >> "$clientdata"
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

# Kill all clients ("k")
if [ "$flags" == k ]; then
	pkill "exefile.exe"
	exit

# Minimize all clients ("m")
elif [ "$flags" == m ]; then

	# Use kdotool to find EVE clients
	for client in $(kdotool search --classname "$windowclass")
	do
		kdotool windowminimize "$client"
	done
	exit
fi

# Ensure client file exists before continuing
if [ ! -f "$clientdata" ]; then
    exit

# Map client data to a temporary array
else
	mapfile -t clients < "$clientdata"
	clientcount="${#clients[@]}"
fi

# Forward/backward cycling ("f") ("b")
if [[ "$flags" == f || "$flags" == b ]]; then

	# Read current cycle from disk
	currentcycle=$(cat "$cycledata")
	
	# Increment cycle forward
	if [ "$flags" == f ]; then
		((currentcycle++))
		
		# Wrap cycle to start
		if [ "$currentcycle" -ge "$clientcount" ]; then
			((currentcycle=0));
		fi

	# Decrement cycle backward
	elif [ "$flags" == b ]; then
		((currentcycle--))
		
		# Wrap cycle to end
		if [ "$currentcycle" -lt 0 ]; then
			((currentcycle="$clientcount"-1));
		fi
	fi
	
	# Save new cycle to disk
	echo "$currentcycle" > "$cycledata"

	# Set target to current cycle
	target="${clients["$currentcycle"]}"
	
# Specific index target selection ("1") ("2")..
else

	# Prevent out-of-bounds selection
	if [ "$flags" -gt "$clientcount" ]; then
		exit
	fi

	# Set target to specified position
	target="${clients["$flags-1"]}"
fi

# Create a temporary kwin script & load it into qdbus
script=$(mktemp)
sed "s/\$TARGET/$target/" $(dirname $0)/switch.js > $script
script_id=$(qdbus org.kde.KWin /Scripting loadScript $script)

# Run script
qdbus org.kde.KWin /Scripting/Script$script_id run
qdbus org.kde.KWin /Scripting/Script$script_id stop

# Clean up temp script
rm $script
