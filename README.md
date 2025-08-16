# EVE-min - a client-switcher for KDE Wayland

A client-switcher for [EVE Online](https://www.eveonline.com/) designed to fully-utilize the EVE client's throttling mechanics by minimizing inactive windows. This is a replacement for [EVE-O Preview](https://github.com/Proopai/eve-o-preview)'s keybound client-switching for those who use "minimize inactive clients" for the performance bump, but don't use the thumbnail preview function.

**NOTE**: This tool isn't against EVE's ToS because it just switches windows. No actions touch the client. Please do not cheat.

# Performance Increase

Many players believe that if a window is out of focus or in another virtual desktop/workspace, it's throttled. But, if a window is out of focus but **not minimized**, it will still consume resources. Without minimizing (5 clients, max graphics), I see this message on the in-game FPS window when switching, and use over 90% of the GPU:

![](https://i.imgur.com/DNjdWlJ.png)

![](https://i.imgur.com/WT68EQP.png) 

With minimizing (5 clients, max graphics), I see these two messages and use less than 30% of the GPU while playing with an active client:

![](https://i.imgur.com/RL25rqR.png)

![](https://i.imgur.com/NxriGDH.png)

# How it Works

EVE-min is multifuctional based on which arguments it's supplied. To switch to a specific client in a lineup, numbered arguments like `"1"` `"2"` and `"3"` are used. To cycle through active clients, `"f"` for forward and `"b"` for backward are used. To refresh the active PIDs, the `"r"` argument is used. The refresh argument is combinable with others with the following syntax: `"r1"`, `"r2"`, `"r3"`, or `"rf"` and `"rb"` to avoid needing to refresh whenever new characters are logged in. However, **refreshing with every switch may have a negative impact** on slower hardware or with too many clients.

# Dependencies

- KDE Plasma because `kdotool` requires Kwin scripting
- The `git` package to download the files you need (optional)

# Installation

1) Open a terminal and enter `cd ~/Documents/`
2) Download EVE-min: `git clone https://github.com/chloroken/eve-min`
3) Download kdotool: `git clone https://github.com/jinliu/kdotool`
4) Copy the kdotool file: `cp ~/Documents/kdotool/kdotool ~/Documents/eve-min/kdotool`
5) Set permissions: `chmod a+x ~/Documents/eve-min/kdotool`
6) Edit `~/Documents/eve-min/charlist.txt` with your character names, noting the existing format
7) Edit `~/Documents/eve-min/blocklist.txt` with the windows you want to block, like the EVE Launcher

# Usage

In KDE Plasma's `System Settings` -> `Keyboard` -> `Shortcuts`, bind the scripts to hotkeys.

![](https://i.imgur.com/OQn4WRL.png) ![](https://i.imgur.com/PJ1Zw2M.png)
   
Example shortcut ideas:
   1) Cycling with automatic refreshing:
       - `bash -c '~/Documents/eve-min/switch.sh "rf"'` refreshes PIDs, then cycles forward in the list
       - `bash -c '~/Documents/eve-min/switch.sh "rb"'` refreshes PIDs, then cycles backward in the list
   2) Targeted switching with manual refreshing:
       - `bash -c '~/Documents/eve-min/switch.sh "r"'` refreshes the PIDs of active characters
       - `bash -c '~/Documents/eve-min/switch.sh "1"'` switches to the first logged-in client in charlist.txt
       - `bash -c '~/Documents/eve-min/switch.sh "2"'` switches to the second logged-in client...
       - `bash -c '~/Documents/eve-min/switch.sh "3"'` switches to the third...

10) Log into your EVE Online characters
11) Use any shortcut with the "r" flag
12) Use your new keybinds to switch between clients

# To Do

1) ~~Cycle script~~
2) ~~Blocklist (for launcher or other purposes)~~
3) Add `kdotool` to `$path`
4) Create an installation script that pulls `kdotool`
5) Allow for higher-count targeted switching (stops at 9 now)
