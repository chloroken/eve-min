# EVE-min - a client-switcher for KDE Wayland

A client-switcher for [EVE Online](https://www.eveonline.com/) designed to fully-utilize the EVE client's throttling mechanics by minimizing inactive windows. This is a replacement for [EVE-O Preview](https://github.com/Proopai/eve-o-preview)'s keybound client-switching for those who use "minimize inactive clients" for the performance bump, but don't use the thumbnail preview function.

**NOTE**: This tool isn't against EVE's ToS because it just switches windows. No actions touch the client.

# Performance Increase

Many players believe that if a window is out of focus or in another virtual desktop/workspace, it's throttled. But, if a window is out of focus but **not minimized**, it will still consume resources. Without minimizing (5 clients, max graphics), I see this message on the in-game FPS window when switching, and use over 90% of the GPU:

![](https://i.imgur.com/DNjdWlJ.png)

![](https://i.imgur.com/WT68EQP.png) 

With minimizing (5 clients, max graphics), I see these two messages and use less than 30% of the GPU while playing with an active client:

![](https://i.imgur.com/RL25rqR.png)

![](https://i.imgur.com/NxriGDH.png)

# How it Works

EVE-min is simple. It looks at a list of your currently-logged-in characters, then tries to switch to them based on which hotkey you entered, minimizing all other clients. If you have 3 hotkeys, pressing the first one will activate the first *logged-in* character in the list. The second keybind will activate the second *logged-in* character in the list, and so on.

This allows you to use the same hotkeys to dynamically switch between multiple "squads" or "lineups" depending on which of your characters are currently online. Furthermore, we can still switch clients even after logging out because the windows are "remembered", which makes changing characters super easy when the login screen would otherwise prevent window name searches.

# Dependencies

- EVE-min requires `kdotool`: https://github.com/jinliu/kdotool
- `kdotool` uses Kwin scripting which necessitates using KDE Plasma
- Install `git` to easily copy the files you'll need

# Installation

1) Open a terminal and enter `cd ~/Documents/`
2) Download eve-min: `git clone https://github.com/chloroken/eve-min`
3) Download kdotool: `git clone https://github.com/jinliu/kdotool`
4) Copy the kdotool file: `cp ~/Documents/kdotool/kdotool ~/Documents/eve-min/kdotool`
5) Set permissions: `chmod a+x ~/Documents/eve-min/kdotool`
6) Edit `~/Documents/eve-min/charlist.txt` with your character names, noting the existing format
7) Edit `~/Documents/eve-min/blocklist.txt` with the windows you want to block, like the EVE Launcher
8) In KDE Plasma's `System Settings` -> `Keyboard` -> `Shortcuts`, bind the scripts to hotkeys:
   
   Example shortcuts:
    - `bash -c '~/Documents/eve-min/switch.sh "r"'` refreshes the PIDs of active characters
    - `bash -c '~/Documents/eve-min/switch.sh "1"'` switches to the first logged-in client in charlist.txt
    - `bash -c '~/Documents/eve-min/switch.sh "2"'` switches to the second logged-in client in charlist.txt
    - `bash -c '~/Documents/eve-min/switch.sh "f"'` cycles forward in the list
    - `bash -c '~/Documents/eve-min/switch.sh "b"'` cycles backward in the list
10) Log into your EVE Online characters
11) Use the shortcut with the "r" flag to lock in your keybinds
12) Use the `switch.sh` keybinds to switch clients with "1", "2", etc, or "f" or "b" to cycle

# To Do

1) Cycle script
2) Blacklist (for launcher or other purposes)
3) Add `kdotool` to `$path`
