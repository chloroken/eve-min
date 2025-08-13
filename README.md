# EVE-minimizer - a client-switcher for KDE Wayland

A client-switcher for [EVE Online](https://www.eveonline.com/) designed to fully-utilize the EVE client's throttling mechanics by minimizing inactive windows. This is a replacement for [EVE-O Preview](https://github.com/Proopai/eve-o-preview)'s keybound client-switching for those who use "minimize inactive clients" for the performance bump, but don't use the thumbnail preview function.

**NOTE: **This tool is not against EVE's ToS because it strictly switches windows. No actions are entered into the client.

# Performance Increase

Many players believe that if a window is out of focus or in another virtual desktop/workspace, it's throttled. But, if a window is out of focus but **not minimized**, it will still consume resources. Without minimizing (5 clients, max graphics), I see this message on the in-game FPS window when switching, and use over 90% of the GPU:

![](https://i.imgur.com/DNjdWlJ.png)

![](https://i.imgur.com/WT68EQP.png) 

With minimizing (5 clients, max graphics), I see these two messages and use less than 30% of the GPU while playing with an active client:

![](https://i.imgur.com/RL25rqR.png)

![](https://i.imgur.com/NxriGDH.png)

# How it Works

EVE-minimizer is simple. It looks at a list of your currently-logged-in characters, then tries to switch to them based on which hotkey you entered. If you have 3 hotkeys, pressing the first one will activate the first *logged-in* character in the list. The second keybind will activate the second *logged-in* character in the list, and so on. This allows you to use the same hotkeys to switch between multiple "squads" or "lineups" depending on which of your characters are currently online. Furthermore, we can still switch clients even after logging out because the windows are "remembered", which makes changing characters super easy when the login screen would otherwise prevent window name searches.

# Dependencies

- EVE-minimizer requires `kdotool`: https://github.com/jinliu/kdotool
- `kdotool` uses Kwin scripting which necessitates using KDE Plasma
- Install `git` to easily copy the files you'll need

# Installation

1) Open a terminal and enter `cd ~/Documents/`
2) Download eve-minimizer: `git clone https://github.com/chloroken/eve-minimizer`
3) Download kdotool: `git clone https://github.com/jinliu/kdotool`
4) Copy the kdotool file: `cp ~/Documents/kdotool/kdotool ~/Documents/eve-minimizer/kdotool`
5) Set permissions: `chmod a+x ~/Documents/eve-minimizer/kdotool`
6) Edit `~/Documents/eve-minimizer/characters.txt` with your character names, noting the existing format
7) In KDE Plasma's `System Settings` -> `Keyboard` -> `Shortcuts`, bind the following to hotkeys:
  - `bash -c '~/Documents/eve-minimizer/refreshpids.sh'`
  - `bash -c '~/Documents/eve-minimizer/switch.sh "1"'`
  - Additional switch.sh binds with `"2"`, `"3"`, `"4"`, etc arguments instead of `"1"`
8) Log into your EVE Online characters
9) Tap the `refreshpids.sh` keybind to lock in your keybinds
10) Use the `switch.sh` keybinds to switch clients
