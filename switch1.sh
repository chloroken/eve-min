#!/bin/bash

# Read PIDs into a working array
pids_file="/tmp/pids.txt"
mapfile -t pids_array < "$pids_file"

# Minimize clients
tar="${pids_array["0"]}" # switch1.sh is 0, switch2.sh is 1, etc
for pid in $(~/Documents/eve-minimizer/kdotool search --classname "steam_app_8500")
do
	if [ "$pid" != "$tar" ]; then
		~/Documents/eve-minimizer/kdotool windowminimize "$pid"
	fi
done

# Tab to target client
~/Documents/eve-minimizer/kdotool windowactivate "$tar"
