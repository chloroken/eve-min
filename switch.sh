#!/bin/bash

# EVE client switcher for KDE. characters.txt is an optional priority list;
# every other live character is appended in alphabetical order.

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
clientlist="$dir/characters.txt"
data="$dir/data"
clientdata="$data/clients.txt"
cycledata="$data/cycle.txt"
# Window classes seen across native Wine, Steam, and Lutris launches.
windowclasses=("exefile.exe" "steam_app_8500" "steam_app_default")
flags="${1:-}"
requested_flags="$flags"
logfile="/tmp/eve-min.log"
logging_enabled=false

# Logging is opt-in. Accept l as part of the combined flag (lm, lf, etc.) or
# as a separate second argument (m l), then remove it from the action flags.
if [[ "$flags" == *l* || "${2:-}" == l ]]; then
	logging_enabled=true
	flags="${flags//l/}"
fi

log_event() {
	[[ "$logging_enabled" == true ]] || return 0
	printf '%(%Y-%m-%dT%H:%M:%S%z)T pid=%s flag=%q %s\n' \
		-1 "$$" "$requested_flags" "$*" >> "$logfile"
}

log_event "invoked"

mkdir -p "$data"

# Prevent overlapping shortcut invocations from racing each other.
lock_dir="${XDG_RUNTIME_DIR:-$data}"
exec 9>"$lock_dir/eve-min-switch.lock"
if ! flock -w 2 9; then
	log_event "lock timeout"
	exit 1
fi
log_event "lock acquired"

find_eve_windows() {
	local windowclass class_selector window_id title
	local -A seen=()

	for windowclass in "${windowclasses[@]}"; do
		# Wine/Steam versions have exposed the identifying value through both
		# KWin's class and classname fields, so query both and deduplicate.
		for class_selector in --class --classname; do
			while IFS= read -r window_id; do
				[[ -n "$window_id" && -z "${seen[$window_id]:-}" ]] || continue
				seen["$window_id"]=1

				# The launcher shares an EVE window class with game clients, but
				# should never be included in switching or bulk minimization.
				title=$(kdotool getwindowname "$window_id" 2>/dev/null)
				[[ "$title" == "EVE Launcher" ]] && continue

				printf '%s\n' "$window_id"
			done < <(kdotool search "$class_selector" "$windowclass" 2>/dev/null)
		done
	done
}

discover_clients() {
	local character window_id title character_name match contains_count i
	local -a found_windows=() window_titles=() character_names=() ordered_clients=()
	local -A already_added=()

	# Build one live window list. KWin may expose EVE character titles either as
	# "Name" or "EVE - Name", so keep both the raw title and a normalized
	# character name.
	while IFS= read -r window_id; do
		[[ -z "$window_id" ]] && continue
		title=$(kdotool getwindowname "$window_id" 2>/dev/null)
		[[ -z "$title" ]] && continue

		character_name="${title#EVE - }"
		found_windows+=("$window_id")
		window_titles+=("$title")
		character_names+=("$character_name")
	done < <(find_eve_windows)

	# Listed, logged-in characters retain their characters.txt order.
	if [[ -f "$clientlist" ]]; then
		while IFS= read -r character || [[ -n "$character" ]]; do
			character="${character%$'\r'}"
			[[ -z "$character" ]] && continue
			match=""

			for ((i = 0; i < ${#found_windows[@]}; i++)); do
				if [[ "${character_names[i]}" == "$character" ]]; then
					match="${found_windows[i]}"
					break
				fi
			done

			# Allow a unique partial match for compatibility with other title
			# formats, without allowing one entry to select unpredictably.
			if [[ -z "$match" ]]; then
				contains_count=0
				for ((i = 0; i < ${#found_windows[@]}; i++)); do
					if [[ "${window_titles[i]}" == *"$character"* ]]; then
						match="${found_windows[i]}"
						((contains_count++))
					fi
				done
				[[ "$contains_count" -eq 1 ]] || match=""
			fi

			if [[ -n "$match" && -z "${already_added[$match]:-}" ]]; then
				ordered_clients+=("$match")
				already_added["$match"]=1
			fi
		done < "$clientlist"
	fi

	# Append every unlisted live character alphabetically. This is also the
	# complete list when characters.txt is absent.
	while IFS=$'\t' read -r character_name window_id; do
		[[ -z "$window_id" ]] && continue
		ordered_clients+=("$window_id")
		already_added["$window_id"]=1
	done < <(
		for ((i = 0; i < ${#found_windows[@]}; i++)); do
			window_id="${found_windows[i]}"
			if [[ -z "${already_added[$window_id]:-}" ]]; then
				printf '%s\t%s\n' "${character_names[i]}" "$window_id"
			fi
		done | LC_ALL=C sort -f -t $'\t' -k1,1 -k2,2
	)

	clients=("${ordered_clients[@]}")
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
		echo "Killing all exefile.exe windows"
		process_count=$(pgrep -cx "exefile.exe" 2>/dev/null || true)
		log_event "kill requested; matched_processes=$process_count"
		if pkill "exefile.exe"; then
			log_event "kill signal sent"
		else
			log_event "kill failed; status=$?"
		fi
		exit
		;;
	m)
		minimized_count=0
		failed_count=0
		while IFS= read -r window_id; do
			[[ -z "$window_id" ]] && continue
			if kdotool windowminimize "$window_id"; then
				((minimized_count++))
			else
				command_status=$?
				((failed_count++))
				log_event "minimize failed; window=$window_id status=$command_status"
			fi
		done < <(find_eve_windows)
		log_event "minimize complete; minimized=$minimized_count failed=$failed_count"
		exit
		;;
esac

discover_clients
log_event "client discovery complete; clients=$clientcount"

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
log_event "switching; active=${active_window:-none} target=$target index=$target_index"

# Minimize the other live clients, then explicitly restore and activate the
# target. Removing MINIMIZED is important: activation alone is not reliable.
for window_id in "${clients[@]}"; do
	if [[ "$window_id" != "$target" ]]; then
		kdotool windowstate --remove above "$window_id"
		kdotool windowminimize "$window_id"
	fi
done

kdotool windowstate --remove minimized --add above "$target"
if kdotool windowactivate "$target"; then
	log_event "switch complete; target=$target"
else
	log_event "switch failed; target=$target status=$?"
fi
kdotool windowstate --remove above "$target"
