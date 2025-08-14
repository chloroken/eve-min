#!/bin/bash

# Steam uses an identifier for games, EVE is 8500
evesteamid="steam_app_8500"

# Locate current working directory
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Choose a target PID based on script argument
mapfile -t pids < "$dir/pids.txt"
tar="${pids["$1-1"]}"

# Prevent out-of-bounds selection
if [ "$1" -gt "${#pids[@]}" ]; then
	exit
fi

# Activate target to bring it forward
$dir/kdotool windowactivate "$tar"

# Minimize other clients
for pid in $($dir/kdotool search --classname "$evesteamid")
do
	if [ "$pid" != "$tar" ]; then
		$dir/kdotool windowminimize "$pid"
	fi
done

# Activate again to "ready" mouse
$dir/kdotool windowactivate "$tar"
