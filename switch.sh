#!/bin/bash

# EVE client switcher for KDE. Character order comes from characters.txt, but
# the set of clients is rebuilt from live windows for every switch.

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
clientlist="$dir/characters.txt"
data="$dir/data"
clientdata="$data/clients.txt"
cycledata="$data/cycle.txt"
windowclass="steam_app_8500" # use steam_app_default for Lutris
flags="${1:-}"

mkdir -p "$data"

# Prevent overlapping shortcut invocations from racing each other.
lock_dir="${XDG_RUNTIME_DIR:-$data}"
exec 9>"$lock_dir/eve-min-switch.lock"
flock -w 2 9 || exit 1

refresh_clients() {
	local character window_id match contains_count i
	local -a eve_windows=() window_titles=() refreshed=()
	local -A already_added=()

	mapfile -t eve_windows < <(kdotool search --classname "$windowclass" 2>/dev/null)

	# Read every title once. This avoids repeated broad regular-expression
	# searches and lets us prefer exact character-name matches.
	for window_id in "${eve_windows[@]}"; do
		window_titles+=("$(kdotool getwindowname "$window_id" 2>/dev/null)")
	done

	while IFS= read -r character || [[ -n "$character" ]]; do
		character="${character%$'\r'}"
		[[ -z "$character" ]] && continue
		match=""

		# EVE normally uses the character name as the complete window title.
		for ((i = 0; i < ${#eve_windows[@]}; i++)); do
			if [[ "${window_titles[i]}" == "$character" ]]; then
				match="${eve_windows[i]}"
				break
			fi
		done

		# Retain compatibility if EVE adds text around the character name, but
		# accept a partial match only when it identifies exactly one window.
		if [[ -z "$match" ]]; then
			contains_count=0
			for ((i = 0; i < ${#eve_windows[@]}; i++)); do
				if [[ "${window_titles[i]}" == *"$character"* ]]; then
					match="${eve_windows[i]}"
					((contains_count++))
				fi
			done
			[[ "$contains_count" -eq 1 ]] || match=""
		fi

		if [[ -n "$match" && -z "${already_added[$match]:-}" ]]; then
			refreshed+=("$match")
			already_added["$match"]=1
		fi
	done < "$clientlist"

	clients=("${refreshed[@]}")
	clientcount="${#clients[@]}"
	if ((clientcount > 0)); then
		printf '%s\n' "${clients[@]}" > "$clientdata"
	else
		: > "$clientdata"
	fi
}

# Actions that do not need a character list.
case "$flags" in
	k)
		pkill "exefile.exe"
		exit
		;;
	m)
		while IFS= read -r window_id; do
			[[ -n "$window_id" ]] && kdotool windowminimize "$window_id"
		done < <(kdotool search --classname "$windowclass" 2>/dev/null)
		exit
		;;
esac

# A leading r is retained for compatibility. Switching is now always refreshed,
# so rf/rb/r1 behave just like f/b/1; r by itself only refreshes the cache.
if [[ "$flags" == r* ]]; then
	flags="${flags#r}"
fi

refresh_clients

if [[ -z "$flags" ]]; then
	exit
fi

if ((clientcount == 0)); then
	exit 1
fi

case "$flags" in
	f|b)
		active_window=$(kdotool getactivewindow 2>/dev/null || true)
		active_index=-1

		for ((i = 0; i < clientcount; i++)); do
			if [[ "${clients[i]}" == "$active_window" ]]; then
				active_index=$i
				break
			fi
		done

		if [[ "$flags" == f ]]; then
			# If focus is outside EVE, forward cycling starts at the first client.
			if ((active_index < 0)); then
				target_index=0
			else
				target_index=$(((active_index + 1) % clientcount))
			fi
		else
			# If focus is outside EVE, backward cycling starts at the last client.
			if ((active_index < 0)); then
				target_index=$((clientcount - 1))
			else
				target_index=$(((active_index - 1 + clientcount) % clientcount))
			fi
		fi
		;;
	*[!0-9]*|'')
		exit 1
		;;
	*)
		# Numbered targets are one-based (1 selects the first live character).
		requested_index=$((10#$flags))
		if ((requested_index < 1 || requested_index > clientcount)); then
			exit 1
		fi
		target_index=$((requested_index - 1))
		;;
esac

target="${clients[target_index]}"
printf '%s\n' "$target_index" > "$cycledata"

# Minimize the other live clients, then explicitly restore and activate the
# target. Removing MINIMIZED is important: activation alone is not reliable.
for window_id in "${clients[@]}"; do
	if [[ "$window_id" != "$target" ]]; then
		kdotool windowstate --remove above "$window_id"
		kdotool windowminimize "$window_id"
	fi
done

kdotool windowstate --remove minimized --add above "$target"
kdotool windowactivate "$target"
