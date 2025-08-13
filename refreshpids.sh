#!/bin/bash

# Locate current working directory
dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Clean up existing PID file
pids="$dir/pids.txt"
rm "$pids"

# Store PIDs of active characters
cat "$dir/characters.txt" | while read -r line || [ -n "$line" ]; do
	$dir/kdotool search --name "$line" >> "$pids"
done
