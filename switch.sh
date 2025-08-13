#!/bin/bash

# Locate current working directory
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Choose a target PID based on script argument
mapfile -t pids < "$dir/pids.txt"
tar="${pids["$1-1"]}"

# Prevent out-of-bounds selection
if [ "$1" -gt "${#pids[@]}" ]; then
	exit
fi

# EVE's steam ID string
evesteamid="steam_app_8500"

# Activate target to bring it forward
$dir/kdotool windowactivate "$tar"

# Minimize other clients
for pid in $($dir/kdotool search --classname "$evesteamid")
do
	if [ "$pid" != "$tar" ]; then
		$dir/kdotool windowminimize "$pid"
		
	fi
done

# Activate target again to "ready" mouse
$dir/kdotool windowactivate "$tar"
