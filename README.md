# EVE-minimizer - a client-switcher for KDE Wayland

A client-switcher for EVE Online designed to fully-utilize the EVE client's throttling mechanics by minimizing inactive windows. This is a replacement for EVE-O Preview for those who check the "minimize inactive clients" button and don't use previews.

Many players believe that if a window is out of focus, it's throtteld. But, if a window is out of focus but **not minimized**, it will still consume resources. Without minimizing (5 clients, max graphics), I see this message when switching and use over 90% of the GPU:

![](https://i.imgur.com/DNjdWlJ.png)

![](https://i.imgur.com/WT68EQP.png) 

With minimizing (5 clients, max graphics), I see these two messages and use less than 30% of the GPU:

![](https://i.imgur.com/RL25rqR.png)

![](https://i.imgur.com/NxriGDH.png)

# Dependencies

- EVE-minimizer requires `kdotool`: https://github.com/jinliu/kdotool
- `kdotool` uses `Kwin` scripting, requiring KDE Plasma.

# Installation

1) Clone this repo into `~/Documents/` and put `kdotool` in the repo folder.
2) Update `characters.txt` with the format "EVE - yourname", one per line, for all desired characters.
   - This order is important. The shortcuts will always follow this 'order' regardless of who's logged on.
4) Copy `switch1.sh` for each client you need a keybind for, changing to `switch2.sh` etc and editing line 8.
   - Once I figure out how to use arguments in Plasma's Shortcuts menu, I'll remove this and use args.
   - Remember, EVE-minimizer is dynamic. It uses `refreshpids.sh` to form an *ordered* line up of current characters.
5) Set up your window manager's shortcuts. For Plasma, use `sh '~/Documents/eve-minimizer/switch1.sh'` etc.
6) Use your shortcut for `refreshpids.sh` after logging into your characters, then use `switch*.sh`.
