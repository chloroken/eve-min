# EVE-min - a client switcher for EVE + KDE Plasma

A client switcher for [EVE Online](https://www.eveonline.com/) designed to fully utilize EVE's throttling mechanics by minimizing inactive client windows. **EVE-min** can also perform blanket actions like killing or minimizing all EVE clients. This tool is congruent with EVE's ToS because no actions touch the client.

# Performance Increase

Many players believe that if a window is out of focus or in another virtual desktop/workspace, that window will be throttled for performance purposes. But, if a window is out of focus but **not minimized**, it will still consume more resources than it needs. Therefore, minimizing inactive windows can dramatically boost peformance.

<div align="center">

This is bad:
   
![](https://i.imgur.com/DNjdWlJ.png)

This is good:

![](https://i.imgur.com/RL25rqR.png)

</div>

Without minimizing (5 clients + max graphics) I use over 90% of the GPU while playing:

<div align="center">

![](https://i.imgur.com/WT68EQP.png) 

With minimizing (5 clients + max graphics) I use less than 30% of the GPU while playing:

![](https://i.imgur.com/NxriGDH.png)
</div>

# How It Works

**EVE-min** uses flags to determine behavior:

   - `"r"` refreshes active clients
   - `"f"` and `"b"` cycle forward and backward
   - `"1"`, `"3"`, and `"12"` target specific clients
   - `"m"` minimizes all clients
   - `"k"` kills all clients

**Combination Flags**: The `"r"` flag can be prepended to target flags like `"rf"`, `"rb"`, `"r1"`, and `"r5"` to perform both actions at once, avoiding the need for a dedicated refresh button. However, be aware that **refreshing with every switch will have a negative performance impact**. Unless performance doesn't matter to you, use combination flags sparingly.

# Dependencies

- [Kwin Compositor](https://github.com/KDE/kwin) *(comes with the [KDE Plasma Desktop Environment](https://kde.org/plasma-desktop/))*
- The `curl` and `git` packages *(you already have these)*

# Installation

1) Install `kdotool` with this console command (one line):
   - `curl -s -L https://github.com/jinliu/kdotool/releases/download/v0.2.2-pre/kdotool.tar.gz | sudo tar xf - -C /usr/local/bin/`
2) Download the **EVE-min** repository with this console command:
   - `git clone https://github.com/chloroken/eve-min ~/Documents/`
4) Use a text editor to open `~/Documents/eve-min/characters.txt` and add your characters
5) Proceed to the **Usage Guide** section below

# Uninstallation

1) Remove the entire `eve-min` directory
2) In a terminal, run `sudo rm /usr/local/bin/kdotool`

# Usage Guide

In KDE Plasma's `System Settings` → `Keyboard` → `Shortcuts`, bind the scripts with the following format:
   - `bash -c '~/Documents/eve-min/switch.sh "<flag>"'`
   - Replace `<flag>` with the desired flag

<div align="center">
   
*Adding a new shortcut:*

![](https://i.imgur.com/OQn4WRL.png)

*Defining the shortcut command & keybind:*

![](https://i.imgur.com/PJ1Zw2M.png)

</div>

   
Example shortcut ideas:
   1) One-button wonder:
      - `bash -c '~/Documents/eve-min/switch.sh "rf"'` refreshes active characters & cycles forward
   2) Targeted switching with manual refreshing:
      - `bash -c '~/Documents/eve-min/switch.sh "r"'` refreshes active characters
      - `bash -c '~/Documents/eve-min/switch.sh "1"'` switches to the first logged-in client
      - `bash -c '~/Documents/eve-min/switch.sh "2"'` switches to the second logged-in...
      - `bash -c '~/Documents/eve-min/switch.sh "3"'` switches to the third...
   3) Quick cycler with "main" button that also refreshes:
      - `bash -c '~/Documents/eve-min/switch.sh "f"'` cycles forward
      - `bash -c '~/Documents/eve-min/switch.sh "b"'` cycles backward
      - `bash -c '~/Documents/eve-min/switch.sh "r1"'` switches to first char & refreshes clients

Example routine:
   1) Log into your EVE Online characters
   2) Use any shortcut with the `"r"` flag
   3) Use your keybinds to switch between clients

# To Do

1) ~~Cycle script~~
2) ~~Blocklist (for launcher or other purposes)~~
3) ~~Add `kdotool` to `$path`~~
4) ~~Create an installation script that pulls `kdotool`~~
5) ~~Allow for higher-count targeted switching (stops at 9 now)~~
6) ~~Add `"m"` flag to minimize all clients~~
7) ~~Add `"k"` flag to kill all clients~~
