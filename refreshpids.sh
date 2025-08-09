#!/bin/bash

# Clean up existing PID files
pids_file="/tmp/pids.txt"
rm $pids_file

# Search for logged-in characters
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cat "$parent_path/characters.txt" | while read -r line || [ -n "$line" ]; do
	# Store PID of active client
	~/Documents/way-switcher/kdotool search --name "$line" >> $pids_file
done

