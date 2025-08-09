# EVE-minimizer is a resource-saving tool

It is a client-switcher, like EVE-O Preview, but instead of previews, EVE-minimizer's primary purpose is to fully-utilize EVE Online's "throttling" mechanics by putting inactive windows out of focus and minimizing them. Without minimizing windows, even if they're out of focus, they still use resources.

# Demonstration

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
5) Set up your window manager's shortcuts. For Plasma, use `sh '~/Documents/eve-minimizer/switch1.sh'` etc.
