# EVE-minimizer is a resource-saving tool

A Linux, Wayland-based client-switcher for EVE Online designed to fully-utilize "throttling" mechanics by minimizing inactive windows. If a window is out of focus but not minimized, it will consume resources. Behold:

Without minimizing, I see this message when switching, and use over 90% of the GPU:

![](https://i.imgur.com/DNjdWlJ.png)

![](https://i.imgur.com/WT68EQP.png) 

With minimizing, I see these two messages, and use less than 30% of the GPU:

![](https://i.imgur.com/RL25rqR.png)

![](https://i.imgur.com/NxriGDH.png)

# Dependencies

EVE-minimizer requires `kdotool`. Get it here: https://github.com/jinliu/kdotool

# Installation

1) Clone this repo and put `kdotool` in the repo folder.
2) Update `characters.txt` with the format "EVE - yourname" with a linebreak after.
3) Copy `switch1.sh` for each client you need a keybind for, changing to `switch2.sh` etc and editing line 8.
   - Once I figure out how to use arguments in Plasma's Shortcuts menu, I'll remove this and use args.
   - EVE-minimizer is dynamic. It uses `refreshpids.sh` to form an *ordered* line up based on current characters.
4) Set up your window manager's shortcuts. For Plasma, use `sh '~/Documents/eve-minimizer/switch1.sh'` etc.
5) Use your shortcut for `refreshpids.sh` after logging into your characters, then use `switch*.sh`.
