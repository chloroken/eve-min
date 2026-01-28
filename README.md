# EVE-min - a performant client-switcher

**EVE-min** is a client-switcher for [EVE Online](https://www.eveonline.com/) built for Linux's [CachyOS](https://cachyos.org/) & [KDE Plasma](https://kde.org/plasma-desktop/) designed primarily for multiboxers who actively juggle many characters across fewer accounts. However, it can also act as a simple 'cycle-switcher' for less-complicated multiboxing setups. It does not generate thumbnail previews.

This software is congruent with EVE's [Terms of Service](https://support.eveonline.com/hc/en-us/articles/8414770561948-EVE-Online-Terms-of-Service) because nothing here touches anything in game.

### DYNAMIC HOTKEYS

Unlike conventional client-switchers, targeted hotkeys in **EVE-min** don't switch between characters. Instead, they switch between active clients based on your chosen character order. The idea is for hotkeys to remain tight regardless of character selection or count. For example, if you've got characters 1, 4, and 7 logged in, the hotkeys would stay as 1, 2, and 3. If you log out of 7 and into 9, the hotkeys are still 1, 2, and 3. This is the purpose of the script.

### PERFORMANCE BOOST

Another focus of this tool is to fully utilize [EVE's throttling mechanics](#eve-online-throttling-mechanics). It achieves this by seamlessly minimizing inactive clients while switching. This offers a dramatic boost in performance, but also eliminates the ability to generate thumbnail previews. Since I don't use previews anyway, this is not a sacrifice.

### PERFORMANT SWITCHING

Because speed and responsiveness are important when multiboxing, this script uses [KWin scripts](https://develop.kde.org/docs/plasma/kwin/) served over dbus to actually manipulate the windows. This bypasses Plasma's frontend and performs our operations in a much faster environment.

# EVE Online Throttling Mechanics

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
- The [qt5-tools](https://archlinux.org/packages/extra/x86_64/qt5-tools/) package for `qdbus` *(comes with KDE Plasma)*
- The [kdotool](https://github.com/jinliu/kdotool) package for window IDing *(easy installation instructions below)*

# Installation

1) Install `qt5-tools` with this command (if not already installed):
   - `sudo pacman -S qt5-tools`
2) Install `kdotool` with this console command (one-liner):
   - `curl -s -L https://github.com/jinliu/kdotool/releases/download/v0.2.2-pre/kdotool.tar.gz | sudo tar xf - -C /usr/local/bin/`
3) Download the **EVE-min** repository to `~/Documents` with these commands:
   - `mkdir ~/Documents/eve-min`
   - `git clone https://github.com/chloroken/eve-min ~/Documents/eve-min`
4) Grant executable permission to the script with this command:
   - `sudo chmod a+x ~/Documents/eve-min/switch.sh`
5) Use a text editor to open `~/Documents/eve-min/characters.txt` to add characters
6) If using Lutris instead of Steam, edit line 12 of `switch.sh` as commented
7) Proceed to the **Usage Guide** section below
# Updating

1) Back up your `characters.txt` file
2) Remove the entire `eve-min` directory
3) Continue from [step 3](#installation) above
4) Replace the new `characters.txt`with your backup

# Uninstall

1) Remove the entire `eve-min` directory
2) To remove kdotool, in a terminal run:
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
   1) One-button wonder (like alt-tabbing):
      - `bash -c '~/Documents/eve-min/switch.sh "rf"'` refreshes active characters & cycles forward
      - NOTE: Including "r" in a command like this makes switching slower. Only use this for basic stuff.
   2) Targeted switching (bind to F1-F5 keys):
      - `bash -c '~/Documents/eve-min/switch.sh "1"'` switches to the first logged-in client
      - `bash -c '~/Documents/eve-min/switch.sh "2"'` switches to the second logged-in...
      - `bash -c '~/Documents/eve-min/switch.sh "3"'` switches to the third...
      - `bash -c '~/Documents/eve-min/switch.sh "r"'` refreshes active clients
      - `bash -c '~/Documents/eve-min/switch.sh "m"'` minimizes all clients

   3) Quick cycler (bind to mouse side buttons):
      - `bash -c '~/Documents/eve-min/switch.sh "f"'` cycles forward
      - `bash -c '~/Documents/eve-min/switch.sh "b"'` cycles backward
      - `bash -c '~/Documents/eve-min/switch.sh "r"'` refreshes active clients

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
10) Have target switches adjust cycle index
