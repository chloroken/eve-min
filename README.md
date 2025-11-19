# EVE-min - a flexible EVE client switcher

**EVE-min** is a client-switcher for [KDE Plasma](https://kde.org/plasma-desktop/) designed to fully utilize [EVE Online's](https://www.eveonline.com/) throttling mechanics. It achieves this by minimizing inactive clients after switching using [KWin scripting](https://develop.kde.org/docs/plasma/kwin/) served via dbus for speed and responsiveness.

This tool may be used as a simple "one-button cycle-switcher" for as few as two characters, but it really shines for those who have many characters across fewer accounts. By supplying a list of character names (`characters.txt`) and invoking a refresh command (`"r"`), a specific *client order* will be locked in — allowing consistent targeted switching, even if intra-client character swaps occur, and even in the login screen.

This software is congruent with EVE's [Terms of Service](https://support.eveonline.com/hc/en-us/articles/8414770561948-EVE-Online-Terms-of-Service) because no client is given any in-game actions.

# EVE's Throttling Mechanics

### Out of Focus vs. Hidden
Many players believe that if an EVE client's window is out of focus or in another virtual desktop/workspace, that window will be throttled for performance purposes. But if a window is out of focus but **not minimized**, it will only be partially throttled.

<div align="center">
   
![](https://i.imgur.com/DNjdWlJ.png)</div>
On the other hand, minimizing a client will trigger both layers of throttling: "Not focused" and "Window hidden". When fully-throttled, an EVE client will consume virtually zero resources from the GPU. Therefore minimizing inactive windows dramatically boosts peformance while multiboxing.

<div align="center">

![](https://i.imgur.com/RL25rqR.png)</div>

### Demonstration (5 clients + max graphics)

Without minimizing I use what feels like the whole GPU:

<div align="center">

![](https://i.imgur.com/WLiRVz2.png)

*(1 active client, 4 unfocused, 0 minimized)*</div>

With minimizing I use less than half of the GPU:

<div align="center">
   
![](https://i.imgur.com/Xo6U6Tr.png)

*(1 active client, 0 unfocused, 4 minimized)*</div>

# How It Works

**EVE-min** is a script that you can run as a command to manipulate your EVE clients. The script does nothing on its own and must be provided flags to indicate which behavior or combination of behaviors you'd like to enact. The flags are as follows:

   - `"r"` refreshes active clients
      - This command creates a list of currently-logged-in clients
      - The list is then used by other commands
   - `"f"` and `"b"` cycle forward and backward through clients
   - `"1"`, `"3"`, and `"12"` target specific clients
      - This command will look for the Nth active character
      - This uses the order listed `characters.txt`
   - `"m"` minimizes all clients
   - `"k"` kills all clients

**Combination Flags**: The `"r"` flag can be prepended to target flags like `"rf"`, `"rb"`, `"r1"`, and `"r5"` to perform both actions at once, avoiding the need for a dedicated refresh button. However, be aware that **refreshing slows down switches**. Unless performance doesn't matter to you, use combination flags sparingly.

# Dependencies

- [KDE Plasma](https://kde.org/plasma-desktop/) for KWin scripting *(technically just the [compositor](https://github.com/KDE/kwin) is needed)*
- The [kdotool](https://github.com/jinliu/kdotool) package for window IDing *(installation instructions below)*

# Installation

1) Install `kdotool` with this console command (one line):
   - `curl -s -L https://github.com/jinliu/kdotool/releases/download/v0.2.2-pre/kdotool.tar.gz | sudo tar xf - -C /usr/local/bin/`
2) Download the **EVE-min** repository to `~/Documents` with this command:
   - `git clone https://github.com/chloroken/eve-min ~/Documents/`
4) Use a text editor to open `~/Documents/eve-min/characters.txt` to add characters
   - The order is important. When refreshing "active characters", this order is used
5) Proceed to the **Usage Guide** section below

# Updating

1) Back up your `characters.txt` file
2) Remove the entire `eve-min` directory
3) Clone the repo as in step 2 of **Installation**
4) Add your `characters.txt` file back

# Uninstallation / Updating

1) Remove the entire `eve-min` directory
2) In a terminal, run:
   - `sudo rm /usr/local/bin/kdotool`

# Usage Guide

### Setting up Shortcuts

In KDE Plasma's `System Settings` → `Keyboard` → `Shortcuts`, bind the scripts with the following format:
   - `bash -c '~/Documents/eve-min/switch.sh "<flag>"'`
   - Replace `<flag>` with the desired flag

<div align="center">
   
*Adding a new shortcut:*

![](https://i.imgur.com/OQn4WRL.png)

*Defining the shortcut command & keybind:*

![](https://i.imgur.com/PJ1Zw2M.png)

</div>

### Example shortcut ideas:
   1) One-button wonder:
      - `bash -c '~/Documents/eve-min/switch.sh "rf"'` refreshes active characters & cycles forward (slow)
   2) Targeted switching with manual refreshing:
      - `bash -c '~/Documents/eve-min/switch.sh "r"'` refreshes active characters
      - `bash -c '~/Documents/eve-min/switch.sh "1"'` switches to the first logged-in client
      - `bash -c '~/Documents/eve-min/switch.sh "2"'` switches to the second logged-in...
      - `bash -c '~/Documents/eve-min/switch.sh "3"'` switches to the third...
   3) Quick cycler with "main" button that also refreshes:
      - `bash -c '~/Documents/eve-min/switch.sh "f"'` cycles forward
      - `bash -c '~/Documents/eve-min/switch.sh "b"'` cycles backward
      - `bash -c '~/Documents/eve-min/switch.sh "rm"'` switches to first char & minimizes all clients

### Example routine:
   1) Log into EVE Online with desired characters
   2) Use any shortcut containing the `"r"` flag
        - This "locks in" active characters based on the order supplied in `characters.txt`
        - This is particularly useful when changing characters - keybinds will persist until a refresh
   3) Use chosen shortcuts to switch between clients

# To Do

1) ~~Cycle script~~
2) ~~Blocklist (for launcher or other purposes)~~
3) ~~Add `kdotool` to `$path`~~
4) ~~Create an installation script that pulls `kdotool`~~
5) ~~Allow for higher-count targeted switching (stops at 9 now)~~
6) ~~Add `"m"` flag to minimize all clients~~
7) ~~Add `"k"` flag to kill all clients~~
8) ~~Refactor using dbus for speed~~
9) ~~Fix cycling issues~~
10) Have target switchds adjust cycle index
